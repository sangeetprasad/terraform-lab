variable "instance_count" {}
variable "instance_type" {
  default = "t3.micro"
}

variable "public_sg" {}
variable "public_subnets" {}
variable "vol_size" {
  default = 10
}

variable "key_name" {}
variable "public_key_path" {}

variable "user_data_path" {}

variable "dbname" {}
variable "dbusername" {}
variable "dbpassword" {}
variable "db_endpoint" {}
