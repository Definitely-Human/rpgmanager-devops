variable "keypair" {
  type        = string
  default     = "rpg-project-key"
  description = "Key pair used to access the Jenkins server."
}

variable "jenkins_instance_size" {
  type        = string
  default     = "t3.medium"
  description = "Size of the Jenkins ec2 instance."
}

variable "key_path" {
  type        = string
  description = "Path to key file used to connect to EC2 instance."
}


