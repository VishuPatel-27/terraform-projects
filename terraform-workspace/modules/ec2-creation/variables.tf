# Variable to specify the AWS region where the resources will be created
variable "region_name" {
  type        = string
  description = "The AWS region to deploy resources in, e.g., us-east-1"
}

# Variable to specify the Amazon Machine Image (AMI) ID for the EC2 instance
variable "image_id" {
  type        = string
  description = "The AMI ID to use for the EC2 instance"
}

# Variable to specify the instance type for the EC2 instance
variable "instance_type" {
  type        = string
  description = "The instance type to use for the EC2 instance, e.g., t2.micro"
}

# Variable to specify the name of the EC2 instance
variable "instance_name" {
  type        = string
  description = "The name to assign to the EC2 instance"
}

# Variable to specify the name of the security group
variable "sg_name" {
  type        = string
  description = "The name to assign to the security group"
}

# Variable to specify the number of EC2 instances to create
variable "replica_count" {
  type        = number
  description = "The number of EC2 instances to create"
}