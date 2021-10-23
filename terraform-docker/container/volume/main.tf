resource "docker_volume" "volume" {
  count = var.volume_count_int
  name  = join("-", [var.volume_name_in, count.index])

  lifecycle {
    prevent_destroy = false
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../../backup/"
    on_failure = continue
  }

  provisioner "local-exec" {
    when       = destroy
    command    = "sudo tar -czvf ${path.cwd}/../../backup/${self.name}.tar.gz ${self.mountpoint}/"
    on_failure = fail
  }
}
