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
  db_instance_type       = "db.t3.micro"
  dbname                 = var.dbname
  dbusername             = var.dbusername
  dbpassword             = var.dbpassword
  db_subnet_group_name   = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.db_sg_id
  skip_db_snapshot       = true
  db_identifier          = "mtc-db"
}

module "loadbalancing" {

  source               = "./loadbalancing"
  public_sg            = module.networking.public_sg_id
  public_subnets       = module.networking.public_subnet_ids
  tg_port              = var.lb_tg_port
  tg_protocol          = var.lb_tg_protocol
  lb_healthy_th        = var.lb_healthy_th
  lb_unhealthy_th      = var.lb_unhealthy_th
  lb_timeout           = var.lb_timeout
  lb_interval          = var.lb_interval
  vpc_id               = module.networking.vpc_id
  lb_listener_port     = var.lb_listener_port
  lb_listener_protocol = var.lb_listener_protocol

}

module "compute" {
  source          = "./compute"
  instance_type   = "t3.micro"
  instance_count  = 1
  vol_size        = 10
  public_sg       = module.networking.public_sg_id
  public_subnets  = module.networking.public_subnet_ids
  public_key_path = "/home/ubuntu/.ssh/keymtc.pub"
  key_name        = "mtckey"
  user_data_path  = "${path.root}/userdata.tpl"
  dbname          = var.dbname
  dbusername      = var.dbusername
  dbpassword      = var.dbpassword
  db_endpoint     = module.database.endpoint
}