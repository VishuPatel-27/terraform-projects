# Define the AWS provider
provider "aws" {
  region = "us-east-1"  # Specify the AWS region
}

# Create the VPC
resource "aws_vpc" "vpc_main" {
  cidr_block       = var.cidr_block  # CIDR block for the VPC
  instance_tenancy = "default"       # Default instance tenancy
  tags = {
    Name = var.vpc_name  # Name tag for the VPC
  }
}

# Create the VPC subnet
resource "aws_subnet" "vpc_subnet" {
  vpc_id                  = aws_vpc.vpc_main.id  # VPC ID to associate the subnet with
  cidr_block              = var.subnet_cidr_block  # CIDR block for the subnet
  availability_zone       = var.subnet_availability_zone  # Availability zone for the subnet
  map_public_ip_on_launch = true  # Assign public IP to instances launched in this subnet
  tags = {
    Name = var.subnet_name  # Name tag for the subnet
  }
}

# Create the Internet Gateway for public access
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc_main.id  # VPC ID to associate the Internet Gateway with
  tags = {
    Name = var.igw_name  # Name tag for the Internet Gateway
  }
}

# Create the route table for the subnet
resource "aws_route_table" "route_tbl" {
  vpc_id = aws_vpc.vpc_main.id  # VPC ID to associate the route table with

  # Route for internal traffic
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }

  # Route for external traffic
  route {
    cidr_block = "0.0.0.0/0"  # Allow all public traffic
    gateway_id = aws_internet_gateway.vpc_igw.id  # Route public access through the Internet Gateway
  }

  tags = {
    Name = var.route_tbl_name  # Name tag for the route table
  }
}

# Associate the route table with the subnet
resource "aws_route_table_association" "route_tbl_sub" {
  subnet_id      = aws_subnet.vpc_subnet.id  # Subnet ID to associate the route table with
  route_table_id = aws_route_table.route_tbl.id  # Route table ID to associate with the subnet
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
  vpc_id      = aws_vpc.vpc_main.id  # VPC ID to associate the security group with

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

# Create the EC2 instance
resource "aws_instance" "example" {
  ami                    = var.image_id  # AMI ID for the EC2 instance
  instance_type          = var.instance_type  # Instance type
  key_name               = aws_key_pair.keypair.key_name  # Key pair for SSH access
  subnet_id              = aws_subnet.vpc_subnet.id  # Subnet ID to launch the instance in
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]  # Security group IDs

  tags = {
    Name = var.instance_name  # Name tag for the EC2 instance
  }

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
