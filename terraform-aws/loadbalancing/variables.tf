# --- loadbalancing/variables.tf ---

variable "public_sg" {}
variable "public_subnets" {}
variable "tg_port" {}
variable "tg_protocol" {}
variable "vpc_id" {}
variable "lb_healthy_th" {}
variable "lb_unhealthy_th" {}
variable "lb_timeout" {}
variable "lb_interval" {}
variable "lb_listener_port" {}
variable "lb_listener_protocol" {}
