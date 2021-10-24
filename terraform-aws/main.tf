# --- root/main.tf ---
module "networking" {
  source                 = "./networking"
  vpc_cidr               = local.vpc_cidr
  access_ip              = var.access_ip
  security_groups        = local.security_groups
  require_db_subnetgroup = true
  public_sn_count        = 2
  private_sn_count       = 3
  max_subnets            = 20
  public_cidrs           = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs          = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "database" {
  source                 = "./database"
  db_size                = 10
  db_engine_version      = "5.7.22"
  db_instance_type       = "db.t2.micro"
  dbname                 = var.dbname
  dbusername             = var.dbusername
  dbpassword             = var.dbpassword
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.db_sg_id
  skip_db_snapshot       = true
  db_identifier          = "mtc-db"
}