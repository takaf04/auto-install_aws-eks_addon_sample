# VPC + Subnet
# --- AZ List ---
data "aws_availability_zones" "az" {
}

# --- VPC ---
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.6.0"

  name                 = var.param.vpc.vpc_name
  cidr                 = var.param.vpc.vpc_cidr_block
  azs                  = data.aws_availability_zones.az.names
  private_subnets      = var.param.vpc.public_subnet_cidr_block
  public_subnets       = var.param.vpc.private_subnet_cidr_block
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # tag for VPC
  vpc_tags = {
    "kubernetes.io/cluster/${var.param.eks.cluster.name}" = "shared"
  }

  # tag for PublicSubnet
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.param.eks.cluster.name}" = "shared"
    "kubernetes.io/role/elb"                                      = "1"
  }

  # tag for PrivateSubnet
  private_subnet_tags = {
    "kubernetes.io/cluster/${var.param.eks.cluster.name}" = "shared"
    "kubernetes.io/role/internal-elb"                             = "1"
  }
}
