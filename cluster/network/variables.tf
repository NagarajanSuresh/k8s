variable "vpc_cidr" {
  type = string
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  default = []
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  default = []
}

variable "prefix" {
  type    = string
  default = "ns2312"
}

variable "region" {
  type = string
}

