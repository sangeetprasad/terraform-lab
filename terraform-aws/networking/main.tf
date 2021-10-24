# -- networking/main.tf -----

data "aws_availability_zones" "available" {}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "aws_vpc" "mtc_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "mtc-${random_integer.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "mtc_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "mtc_public_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "mtc_public_subnet_rt_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.mtc_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.mtc_public_rt.id
}

resource "aws_subnet" "mtc_private_subnet" {
  count             = var.private_sn_count
  vpc_id            = aws_vpc.mtc_vpc.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = random_shuffle.az_list.result[count.index]
  tags = {
    Name = "mtc_private_subnet_${count.index + 1}"
  }
}

resource "aws_internet_gateway" "mtc_igw" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "mtc-igw-${random_integer.random.id}"
  }
}

resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id
  tags = {
    Name = "mtc_public_rt-${random_integer.random.id}"
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_igw.id
}



resource "aws_default_route_table" "mtc_private_rt" {
  default_route_table_id = aws_vpc.mtc_vpc.default_route_table_id
  tags = {
    Name = "mtc-private-rt-${random_integer.random.id}"
  }
}


resource "aws_security_group" "mtc_sg" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.mtc_vpc.id

  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      description = ingress.value.desc
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.proto
      cidr_blocks = ingress.value.cidrs
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "mtc_sg_${each.value.name}"
  }
}



resource "aws_db_subnet_group" "mtc_rds_subnetgroup" {
  count      = var.require_db_subnetgroup ? 1 : 0
  name       = "mtc_rds_subnetgroup"
  subnet_ids = aws_subnet.mtc_private_subnet[*].id

  tags = {
    Name = "mtc_rds_subnetgroup"
  }
}

