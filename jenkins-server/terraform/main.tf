
terraform {
  required_version = "~> 1.8.2"
  required_providers {
    aws = {
       source = "hashicorp/aws"
       version = "~> 5.25"
    }
    ansible = {
      source = "ansible/ansible"
      version = "1.3"
    }
  }

  # backend "s3" {
  #   bucket = "terraform-lrn"
  #   key    = "dev/eks-cluster/terraform.tfstate"
  #   region = "eu-central-1"

  #   dynamodb_table = "dev-ekscluster"
  # }

}

provider "aws" {
  region  = "eu-central-1"
  profile = "default"
}

# create default vpc if one does not exit
resource "aws_default_vpc" "default_vpc" {

  tags    = {
    Name  = "default vpc"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


# create default subnet if one does not exit
resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available_zones.names[0]

  tags   = {
    Name = "default subnet"
  }
}

locals {
  name = "rpg-project" # TODO: Import name from VPC project
}

module "jenkins_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.2"

  name = "${local.name}-jenkins-sg"
  description = "Security group for SSH Port and 8080 to be open for everybody for Jenkins."
  vpc_id = aws_default_vpc.default_vpc.id

  #Ingress rules
  ingress_rules = ["ssh-tcp", "http-8080-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  #Egress rules
  egress_rules = ["all-all"]

  tags   = {
    Name = "Jenkins server security group"
  }
}


# use data source to get a registered amazon linux 2 ami
data "aws_ami" "amz_linux2" {
    most_recent = true
    owners      = ["amazon"]

    filter {
        name    = "name"
        values  = ["amzn2-ami-hvm-*-gp2"]
    }

    filter {
        name    = "root-device-type"
        values  = ["ebs"]
    }

    filter {
        name    = "virtualization-type"
        values  = ["hvm"]
    }

    filter {
        name    = "architecture"
        values  = ["x86_64"]
    }

}


# launch the ec2 instance and install website
resource "aws_instance" "jenkins_ec2_instance" {
  ami                    = data.aws_ami.amz_linux2.id
  instance_type          = var.jenkins_instance_size
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [module.jenkins_sg.security_group_id]
  key_name               = var.keypair

  tags = {
    Name = "Jenkins Server"
  }
}


# an empty resource block
resource "null_resource" "execute_ansible" {

  # ssh into the ec2 instance
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_path)
    host        = aws_instance.jenkins_ec2_instance.public_ip
  }

  # set permissions and run the install_jenkins.sh file

  provisioner "local-exec" {
    command = "echo 'Waiting...' && sleep 5 && ANSIBLE_CONFIG=../ansible/ansible.cfg ansible-playbook ../ansible/playbook.yaml"

  }

  provisioner "remote-exec" {
    inline = [
      "echo \"Admin password: $(sudo cat /var/lib/jenkins/secrets/initialAdminPassword)\"",
    ]
  }
  # wait for ec2 to be created
  depends_on = [aws_instance.jenkins_ec2_instance, ansible_host.jenkins_host]
}


# print the url of the jenkins server
output "website_url" {
  value     = join ("", ["http://", aws_instance.jenkins_ec2_instance.public_dns, ":", "8080"])
}

resource "ansible_host" "jenkins_host" {
  name = aws_instance.jenkins_ec2_instance.public_ip
  groups = ["jenkins"]

  variables = {
      ansible_user = "ec2-user",
      ansible_ssh_private_key_file = var.key_path,
      ansible_python_interpreter   = "/usr/bin/python3",
  }
}