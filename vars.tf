variable "COMPONENT" {}
variable "ENV" {}
variable "INSTANCE_COUNT" {}
variable "APP_INSTANCE_CLASS" {}
variable "PRIVATE_SUBNET_ID" {}
variable "VPC_ID" {}
variable "APP_PORT" {}
variable "WORKSTATION_IP" {}
variable "PROMETHEUS_IP" {}
variable "PRIVATE_LB_ARN" {}
variable "PUBLIC_LB_ARN" {}
variable "PRIVATE_ZONE_ID" {}
variable "PRIVATE_LB_DNS" {}
variable "PRIVATE_LISTNER_ARN" {}
variable "ALLOW_SG_CIDR" {}
variable "DOCDB_ENDPOINT" {
  default = "null"
}
variable "REDDIS_ENDPOINT" {
  default = "null"
}
variable "MYSQL_ENDPOINT" {
  default = "null"
}


