provider "aws" {
  region = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
#0.1 Creating back-end configuration for store tfstate remotly in bucket S3
terraform {
  backend "s3"{
    bucket = "your-bucket-name"
    key = "your-bucket-name/s3/terraform.tfstate"
    region = "us-east-1"
    #DynamoDB table name
    dynamodb_table = "<your-dynamodb-table-name>"
    encrypt = true
  }
}

#0. Creating bucket s3 for store tfstate remotly in bucket S3
resource "aws_s3_bucket" "terraform-state" {
  bucket = "<your-bucket-name>"
  #It prevents accidental deletion of S3 bucket
  lifecycle {
    prevent_destroy = true
  }
  #Enable versioning to see full revision history of our state files.
  versioning {
    enabled = true
  }
  #Enable server-side encryption(SSE)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
#0.5 Creating DynamoDB table to user for locking
resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name = "terraform-test-locks"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

#1. Creating vpc
resource "aws_vpc" "vpc-prod" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
    tags = {
    Name = "production"
  }
}

#2. Creating an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-prod.id

}
#3. Creating Custom Route Table
resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.vpc-prod.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Prod"
  }
}

#4. Creating subnet
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.vpc-prod.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "prod-subnet"
  }
}

#5. Associating subnet with Route Table
resource "aws_route_table_association" "route-table-association-subnet-1" {
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

#6. Creating Security Group to allow port 22,80,443
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow WEB"
  vpc_id      = aws_vpc.vpc-prod.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

#7. Creating a network interface with an ip in the subnet that was created in step 4
resource "aws_network_interface" "web-server-cosme" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]

}

#8. Assigning an elastic IP to the network interface created in step 7
resource "aws_eip" "one-elastic-ip" {
  vpc                       = true
  network_interface         = aws_network_interface.web-server-cosme.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.igw,aws_instance.web-server-instance]
  
}
output "server_public_ip" {
  value = aws_eip.one-elastic-ip.public_ip
}
#9. Creating Ubuntu server and install/enable apache2
resource "aws_instance" "web-server-instance" {
  ami           = "ami-06878d265978313ca"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "your-key"

   network_interface {
    network_interface_id = aws_network_interface.web-server-cosme.id
    device_index         = 0
  }

  user_data = <<-EOF
            #! /bin/bash
            sudo apt-get update
            sudo apt-get install -y apache2
            sudo systemctl start apache2
            sudo systemctl enable apache2
            echo "The page was created by Cosm" | sudo tee /var/www/html/index.html
            EOF
  tags = {
    Name = "web-server"
  }
  
}
#Outputs for instances data
output "server_private_ip" {
    value = aws_instance.web-server-instance.private_ip
  }
  output "server_id" {
    value = aws_instance.web-server-instance.id
  }