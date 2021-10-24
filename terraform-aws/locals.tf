
locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "Allow public access"
      ingress = {
        ssh = {
          desc  = "port 22 access"
          from  = 22
          to    = 22
          proto = "tcp"
          cidrs = [var.access_ip]
        }
        http = {
          desc  = "port 80 access"
          from  = 80
          to    = 80
          proto = "tcp"
          cidrs = [var.access_ip]
        }
      }
    }
    rds = {
      name        = "rds_sg"
      description = "Allow rds access from vpc"
      ingress = {
        rds = {
          desc  = "port 3306 access"
          from  = 3306
          to    = 3306
          proto = "tcp"
          cidrs = [local.vpc_cidr]
        }
      }

    }

  }
}