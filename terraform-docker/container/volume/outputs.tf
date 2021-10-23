output "volume_output" {
  value = docker_volume.volume[*].name
}