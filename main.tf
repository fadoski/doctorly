terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "test_server" {
  ami           = "ami-00874d747dde814fa"
  instance_type = "t2.micro"

user_data = <<EOF
#!/bin/bash
sudo apt-get install amazon-linux-extras install ansible2 -y
EOF

key_name = "doctorly"

provisioner "local-exec"{
  command = "sleep 180; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook - u ubuntu --private-key ./doctorly.pem -i '${aws_instance.test_server.public_ip}, playbook.yml"
}
  tags = {
    Name = var.instance_name
  }
}