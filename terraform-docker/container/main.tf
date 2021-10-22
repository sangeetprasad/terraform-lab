# Create a container
resource "docker_container" "container" {
  count = var.count_in
  image = var.image_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result])
  ports {
    internal = var.int_port_in
    external = var.ext_port_in[count.index]
  }

  volumes {
    container_path = var.container_path_in
    volume_name    = docker_volume.volume[count.index].name
  }
}

resource "docker_volume" "volume" {
  count = var.count_in
  name  = join("-", [var.name_in, terraform.workspace, random_string.random[count.index].result, "volume"])

  lifecycle {
    prevent_destroy = false
  }
}


resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}