terraform {
    required_providers {
      aws = {
    source = "hashicorp/aws"
    version = "3.0"
    }
    }
}
#PROVIDER
provider "aws" {
  region = "us-east-1"
}
#VPC
 resource "aws_vpc" "Deployment_5_VPC" {
    cidr_block = "172.20.0.0/16"
   tags = {
    Name = "Deployment_5_VPC"
   }
 }
#SUBNET
 resource "aws_subnet" "Deployment_5_SUBNET" {
    vpc_id = aws_vpc.Deployment_5_VPC.id
     cidr_block = "172.20.0.0/18" 
     map_public_ip_on_launch = true
    tags = {
      Name = "Deployment_5_SUBNET"
    } 
 }
#INTERNET GATEWAY
resource "aws_internet_gateway" "Deployment_5_GATEWAY" {
  vpc_id = aws_vpc.Deployment_5_VPC.id
}
#ROUTE TABLE
 resource "aws_route_table" "Deployment_5_ROUTE" {
   vpc_id = aws_vpc.Deployment_5_VPC.id
   route  {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.Deployment_5_GATEWAY.id
   } 
 }

 #ROUTE TABLE ASSOCIATION
resource "aws_route_table_association" "Deployment_5_Association" {
  subnet_id = aws_subnet.Deployment_5_SUBNET.id
  route_table_id = aws_route_table.Deployment_5_ROUTE.id
}

#INSTANCES
resource "aws_instance" "Deployment_5_Jenkins" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Deployment_5_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Deployment_5_Security.id]
  user_data = "${file("JenkinsInstall.txt")}"
  tags = {
    Name = "Deployment_5_Jenkins"
  }
}

resource "aws_instance" "Deployment_5_Docker" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Deployment_5_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Deployment_5_Security.id]
  tags = {
    Name = "Deployment_5_Docker"
  }
}

resource "aws_instance" "Deployment_5_Terraform" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "JenKey"
  subnet_id = aws_subnet.Deployment_5_SUBNET.id
  vpc_security_group_ids = [aws_security_group.Deployment_5_Security.id]
  tags = {
    Name = "Deployment_5_Terraform"
  }
}
#SECURITY GROUPS
resource "aws_security_group" "Deployment_5_Security" {
  name = "deployment_5_Security"
  description = "Security group to open certain ports"
  vpc_id = aws_vpc.Deployment_5_VPC.id
  
  ingress  {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress  {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 5000
    to_port = 5000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress  {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    protocol = "-1"
    to_port = 0
  } 
}