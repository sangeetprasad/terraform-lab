module "image" {
  source   = "./image"
  image_in = each.value.image
  for_each = local.deployment
}


module "container" {
  for_each    = local.deployment
  source      = "./container"
  count_in    = each.value.container_count
  image_in    = module.image[each.key].image_out
  name_in     = each.key
  int_port_in = each.value.int
  ext_port_in = each.value.ext
  volumes_in  = each.value.volumes
}


