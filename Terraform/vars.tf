variable "location" {
  type    = string
  default = "uksouth"
}

variable "failover_location" {
  type    = string
  default = "ukwest"
}

variable "prefix" {
  type    = string
  default = "demoSQLDB"
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "private-cidr" {
  type    = string
  default = "10.0.0.0/24"
}
