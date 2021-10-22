module "image" {
  source   = "./image"
  image_in = var.image[terraform.workspace]
}

module "container" {
  source            = "./container"
  depends_on        = [null_resource.dockervol]
  count             = local.container_count
  image_in          = module.image.image_out
  name_in           = join("-", ["nodered", terraform.workspace, random_string.random[count.index].result])
  int_port_in       = var.int_port
  ext_port_in       = var.ext_port[terraform.workspace][count.index]
  container_path_in = "/data"
  host_path_in      = "${path.cwd}/noderedvol"
}


resource "random_string" "random" {
  count   = local.container_count
  length  = 4
  special = false
  upper   = false
}

resource "null_resource" "dockervol" {

  provisioner "local-exec" {
    command = "mkdir noderedvol/ || true && sudo chown -R 1000:1000 noderedvol/"

  }

}