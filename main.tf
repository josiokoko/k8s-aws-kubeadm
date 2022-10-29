
provider "aws" {
  region = "us-east-1"
}


module "network" {
  # source     = "weibeld/kubeadm/aws//modules/network"
  # version    = "~> 0.2"
  source     = "./modules/network"
  cidr_block = "10.0.0.0/16"
  tags       = { "terraform-kubeadm:cluster" = module.cluster.cluster_name }
}


module "cluster" {
  source               = "weibeld/kubeadm/aws"
  version              = "~> 0.2"
  vpc_id               = module.network.vpc_id
  subnet_id            = module.network.subnet_id[0]
  num_workers          = 2
  worker_instance_type = "t2.micro"
  master_instance_type = "t2.medium"
  tags                 = { "terraform-kubeadm:node" = module.cluster.cluster_name }
}


