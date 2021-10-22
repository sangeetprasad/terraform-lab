variable "image" {
  type        = map(any)
  description = "image for container"
  default = {
    dev  = "nodered/node-red:latest",
    prod = "nodered/node-red:latest-minimal"
  }
}
variable "container_count" {
  default = 1
}

variable "ext_port" {
  type = map(any)
  validation {
    condition     = max(var.ext_port["dev"]...) < 65536 && min(var.ext_port["dev"]...) > 1900
    error_message = "The external port must be < 65536 && > 1900."
  }

  validation {
    condition     = max(var.ext_port["prod"]...) <= 1900 && min(var.ext_port["prod"]...) > 1800
    error_message = "The external port must be < 1900 && > 1800."
  }
}

variable "int_port" {
  default = 1880
  type    = number

  validation {
    condition     = var.int_port == 1880
    error_message = "The internal port must be 1880."
  }
}


locals {
  container_count = length(var.ext_port[terraform.workspace])
}