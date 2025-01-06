variable "env" {}
variable "instance_type"{}
variable "vpc_id" {}
variable "subnet_id" {}
variable "component" {}
variable "zone_id"{}
variable "lb_type" {
  default = null
}
variable "lb_subnets" {}
variable "lb_needed"{
  default = null
}
variable "server_app_port" {}
variable "app_port"{}
variable "vault_token" {}
variable "bastion_nodes" {}
variable "lb_cidr_block" {
  default = null
}
variable "certificate_arn" {
  default = null
}
variable "ssl_policy" {
  default = null
}
variable "lb_app_port" {
  default = {}
}