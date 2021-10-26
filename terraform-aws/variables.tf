# --- root/variables.tf ---

variable "aws_region" {
  default = "us-west-2"
}

variable "access_ip" {
  type = string
}


variable "dbname" {
  type = string
}
variable "dbusername" {
  type      = string
  sensitive = true
}
variable "dbpassword" {
  type      = string
  sensitive = true
}


variable "lb_tg_port" {}
variable "lb_tg_protocol" {}

variable "lb_healthy_th" {}
variable "lb_unhealthy_th" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}