locals {
  env = var.env
}

module "vpc" {
  source = "./modules/vpc"
  env    = var.env
  vpc_cidr_block = var.vpc_cidr_block
  public_subnet  = var.public_subnet
  private_subnet = var.private_subnet
  cluster_name   = var.cluster_name
}

module "sg" {
  source = "./modules/sg"
  env    = var.env
  vpc_id = module.vpc.vpc_id
}