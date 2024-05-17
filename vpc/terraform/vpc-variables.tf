# vpc input variables

# vpc name
variable "vpc_name" {
  description = "vpc name"
  type = string
  default = "vpc"
}

# vpc cidr block
variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type = string
  default = "10.0.0.0/16"
}

# vpc public subnets
variable "vpc_public_subnets" {
  description = "vpc public subnets"
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# vpc private subnets
variable "vpc_private_subnets" {
  description = "vpc private subnets"
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

# vpc enable nat gateway (true or false)
variable "vpc_enable_nat_gateway" {
  description = "enable nat gateways for private subnets outbound communication"
  type = bool
  default = true
}

# vpc single nat gateway (true or false)
variable "vpc_single_nat_gateway" {
  description = "enable only single nat gateway in one availability zone "
  type = bool
  default = true
}