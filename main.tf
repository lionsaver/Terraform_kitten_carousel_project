terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.58.0"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"

}

locals {
  link = "https://raw.githubusercontent.com/lionsaver/Terraform_kitten_carousel_project/main/static-web"
}

resource "aws_instance" "tff-ec2" {
  ami             = "ami-006dcf34c09e50022"
  instance_type   = "t2.micro"
  key_name        = "first-key"
  security_groups = [aws_security_group.ssh_http.name]
  # security_groups = ["ssh_http"]
  user_data       = filebase64("user-data.sh")
  tags = {
    Name = "Kitten_Carousel"
  }
  # user_data = <<-EOF
  #     #!/bin/sh
  #     yum update -y
  #     yum install httpd -y
  #     yum install wget -y
  #     FOLDER="https://raw.githubusercontent.com/lionsaver/Terraform_kitten_carousel_project/main/static-web"
  #     cd /var/www/html
  #     wget $FOLDER/index.html
  #     wget $FOLDER/cat0.jpg
  #     wget $FOLDER/cat1.jpg
  #     wget $FOLDER/cat2.jpg
  #     wget $FOLDER/cat3.png
  #     systemctl start httpd
  #     systemctl enable httpd
  #     EOF
}
resource "aws_security_group" "ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow ssh and http inbound traffic"
#   vpc_id      = aws_vpc.main.id
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

output "kitten_carousel_public_ip" {
    value = "http://${aws_instance.tff-ec2.public_ip}"
}

