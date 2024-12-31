variable "cidr_block" {
  type = string
  description = "this variable holds the value of CIDR block"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "subnet_cidr_block" {
  type = string
  description = "this variable holds the value of CIDR block for subnet"

  # example
  # cidr_block = "x.x.x.x/16"
}

variable "vpc_name" {
  type = string
  description = "name of your VPC"
}

variable "subnet_name" {
  type = string
  description = "name of your subnet which is associated to the VPC we created"
}

variable "subnet_availability_zone" {
    type = string
    description = "name of the availability zone in which want to create the subnet"
}

variable "igw_name" {
  type = string
  description = "name of your internet gateway"
}

variable "route_tbl_name" {
  type = string
  description = "name of your route table"
}

variable "image_id" {
  type        = string
  description = "The id of the machine image (AMI) to use for the server."
}

variable "instance_type" {
  type        = string
  description = "The id of the instance type to use for the server."
}

variable "instance_name" {
  type = string
  description = "Name of the EC2 instance (server name)"
}

variable "sg_name" {
  type = string
  description = "Name of the security group"
}