module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~>5.1.0"


  name = "${local.name}-public-bastion-sg"
  description = "Security group for SSH Port open for everybody for public bastion."
  vpc_id = module.vpc.vpc_id

  #Ingress rules
  ingress_rules = ["ssh-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  #Egress rules
  egress_rules = ["all-all"]
  tags=local.common_tags
}