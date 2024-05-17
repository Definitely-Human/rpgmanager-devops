

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 Instance Type"
}

variable "instance_keypair" {
  type        = string
  description = "AWS EC2 Key pair that need to be associated with EC2 Instance."
}
