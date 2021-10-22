module "nodered_image" {
  source   = "./image"
  image_in = var.image["nodered"][terraform.workspace]
}

module "influxdb_image" {
  source   = "./image"
  image_in = var.image["influxdb"][terraform.workspace]
}


module "container" {
  source            = "./container"
  count             = local.container_count
  image_in          = module.nodered_image.image_out
  name_in           = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  int_port_in       = var.int_port
  ext_port_in       = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
}


resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

