#define the provider
provider "aws" {
    # define the region
    region = "us-east-1"
}

# creating the VPC
resource "aws_vpc" "vpc_main" {
  cidr_block = var.cidr_block
  instance_tenancy = "default"
  tags = {
    # name of the vpc
    Name = var.vpc_name
  }
}

# creating the VPC subnet
resource "aws_subnet" "vpc_subnet" {

  # vpc id under which we wanna associate the subnet
  vpc_id     = aws_vpc.vpc_main.id

  # define the CIDR block for subnet
  cidr_block = var.subnet_cidr_block
  
  # availability zone for the subnet
  availability_zone = var.subnet_availability_zone

  # true value to indicate that instances launched into -
  # the subnet should be assigned a public IP address
  map_public_ip_on_launch = true

  tags = {
    # name of the subnet
    Name = var.subnet_name
  }
}

# creating the Internet Gateway for public access
resource "aws_internet_gateway" "vpc_igw" {

  # associated with the VPC we created
  vpc_id = aws_vpc.vpc_main.id
  tags = {
    # name of the IGW
    Name = var.igw_name
  }
}

# creating the aws route table for the subnet
resource "aws_route_table" "example" {

  # vpc id
  vpc_id = aws_vpc.vpc_main.id

  # route for the internal traffic
  route {
    cidr_block = var.cidr_block
    gateway_id = "local"
  }
  
  # route for the external traffic
  route {
    # allow all public traffic
    cidr_block = "0.0.0.0/0"

    # this route all public access using the Internet Gateway that
    # we created
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    # name of the route table
    Name = var.route_tbl_name
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "ec2-keypair"  # Replace with your desired key name
  public_key = file("id_rsa.pub")  # Replace with the path to your public key file
}


# creating the security group for EC2 instace
resource "aws_security_group" "ec2-sg" {

  name = var.sg_name
  description = "Security Group for the EC2 instance"
  vpc_id      = aws_vpc.vpc_main.id

  ingress{
    description = "allow SSH on port 22"
    cidr_blocks = "0.0.0.0/0"
    from_port = 22
    protocol = "tcp"
    to_port = 22
  }
  
  ingress{
    description = "allow HTTP on port 80"
    cidr_blocks = "0.0.0.0/0"
    from_port = 80
    protocol = "tcp"
    to_port = 80
  }

  egress{
    description = "allow all outbound traffic"
    cidr_blocks = "0.0.0.0/0"
    protocol = "-1" # semantically equivalent to all ports
  }

  tags = {
    Name = var.sg_name
  }

}

# creating the EC2 instance (server)
resource "aws_instance" "example" { 
  ami = var.image_id # AMI for the EC2 instance
  instance_type = var.instance_type # type of the EC2 instance
  key_name = aws_key_pair.keypair.key_name # keypair to accces the EC2 instance
  subnet_id = aws_subnet.vpc_subnet.id
  
  vpc_security_group_ids = [aws_security_group.ec2-sg.id]

  tags = { 
    Name = var.instance_name # name of the server (EC2 instance)
  }
  
  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key  = file("id_rsa")
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y nginx" 
    ]
  }

}
