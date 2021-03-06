variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    nodered = {
      dev  = "nodered/node-red:latest",
      prod = "nodered/node-red:latest-minimal"
    }

    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2",
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }

    grafana = {
      dev  = "grafana/grafana:latest",
      prod = "grafana/grafana:latest"
    }
  }
}
variable "container_count" {
  default = 4
}

variable "ext_port" {
  type = map(any)
  # validation {
  #   condition     = max(var.ext_port["dev"]...) < 65536 && min(var.ext_port["dev"]...) > 1900
  #   error_message = "The external port must be < 65536 && > 1900."
  # }

  # validation {
  #   condition     = max(var.ext_port["prod"]...) <= 1900 && min(var.ext_port["prod"]...) > 1800
  #   error_message = "The external port must be < 1900 && > 1800."
  # }
}

variable "int_port" {
  default = 1880
  type    = number

  # validation {
  #   condition     = var.int_port == 1880
  #   error_message = "The internal port must be 1880."
  # }
}


# locals {
#   container_count = length(var.ext_port[terraform.workspace])
# }