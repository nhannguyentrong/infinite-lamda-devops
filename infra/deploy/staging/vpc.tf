module "vpc_custom" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.6.0"

    name = var.vpc_name
    cidr = var.vpc_cidr

    azs = local.availability_zones
    public_subnets = var.vpc_public_subnets
    private_subnets = var.vpc_private_subnets
    enable_nat_gateway = true
    single_nat_gateway = true
    tags = var.my_tags
}