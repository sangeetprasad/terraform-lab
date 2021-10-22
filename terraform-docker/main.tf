locals {
  deployment = {
    nodered = {
      container_count = length(var.ext_port["nodered"][terraform.workspace])
      image           = var.image["nodered"][terraform.workspace]
      int             = 1880
      ext             = var.ext_port["nodered"][terraform.workspace]
      container_path  = "/data"
    }
    influxdb = {
      container_count = length(var.ext_port["influxdb"][terraform.workspace])
      image           = var.image["influxdb"][terraform.workspace]
      int             = 1886
      ext             = var.ext_port["influxdb"][terraform.workspace]
      container_path  = "/var/lib/influxdb"
    }
  }
}


module "image" {
  source   = "./image"
  image_in = each.value.image
  for_each = local.deployment
}


module "container" {
  for_each          = local.deployment
  source            = "./container"
  count_in          = each.value.container_count
  image_in          = module.image[each.key].image_out
  name_in           = each.key
  int_port_in       = each.value.int
  ext_port_in       = each.value.ext
  container_path_in = each.value.container_path
}


