# Configure the AWS Provider with the specified region
provider "aws" {
  region = var.region_name
}

# Create the key pair for EC2 instance access
resource "aws_key_pair" "keypair" {
  key_name   = "ec2-keypair"  # Key name
  public_key = file("~/.ssh/id_rsa.pub")  # Path to the public key file
}

# Create the security group for the EC2 instance
resource "aws_security_group" "ec2-sg" {
  name        = var.sg_name  # Security group name
  description = "Security Group for the EC2 instance"

  # Ingress rule to allow SSH access
  ingress {
    description = "allow SSH on port 22"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  # Ingress rule to allow HTTP access
  ingress {
    description = "allow HTTP on port 80"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  # Egress rule to allow all outbound traffic
  egress {
    description = "allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.sg_name  # Name tag for the security group
  }
}

# Create an EC2 instance with the specified AMI, instance type, and tags
resource "aws_instance" "example" {
  ami = var.image_id
  instance_type = var.instance_type
  key_name = aws_key_pair.keypair.key_name  # Key pair for SSH access
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]  # Security group for the instance
  tags = { 
  Name = var.instance_name 
  }

  count = var.replica_count  # Number of instances to create

  # Connection details for remote provisioners
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa") # Path to the private key file for SSH access
    host        = self.public_ip
  }

  # Provisioner to install Nginx on the instance
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx"
    ]
  }

}