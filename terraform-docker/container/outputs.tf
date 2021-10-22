output "ip-address-port" {
  value = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address], i.ports[*]["external"])]
  # value       = [for i in docker_container.nodered_container[*] : join(":", [i.ip_address, i.ports[0].external])]

  description = "The IP address of the container"
}

output "container-name" {
  value       = docker_container.nodered_container.name
  description = "The Name of the container"
}
