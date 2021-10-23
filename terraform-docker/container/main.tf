# Create a container
resource "docker_container" "container" {
  count = var.count_in
  image = var.image_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }

  dynamic "volumes" {

    for_each = var.volumes_in
    content {
      container_path = volumes.value["container_path_each"]
      volume_name    = module.volume[count.index].volume_output[volumes.key]
    }
  }

  provisioner "local-exec" {
    command    = "echo  ${self.name}: ${self.ip_address}:${self.ports[0].external} >> ${path.cwd}/../container.txt"
    on_failure = fail
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "rm -f ${path.cwd}/../container.txt"
    on_failure = continue
  }

}


module "volume" {
  source           = "./volume"
  count            = var.count_in
  volume_count_int = length(var.volumes_in)
  volume_name_in   = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result, "volume"])
}

resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}