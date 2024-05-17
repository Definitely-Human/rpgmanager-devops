resource "aws_eip" "bastion_eip" {
  instance = module.ec2bastion.id
  domain = "vpc"
  tags     = local.common_tags
  depends_on = [module.ec2bastion, module.vpc]
}