# Output the public IP address of the instance
# This output will provide the public IP address of the EC2 instance(s) created by this module
output "public_ip" {
  value = [for instance in aws_instance.example : instance.public_ip]
}