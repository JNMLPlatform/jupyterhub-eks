module "aws-vpc" {
  source = "../terraform-modules/aws-vpc"

  project_name       = "billerxchange_ml"
  availability_zones = ["us-east-1a", "us-east-1b"]
  cidr_block         = "10.10.0.0/16"
  cidr_newbits       = "4"
}

module "eks-cluster" {
  source = "../terraform-modules/aws-eks"

  project_name         = "billerxchange_ml"
  vpc_id               = module.aws-vpc.vpc_id
  subnet_ids           = module.aws-vpc.public_subnets
  k8s_version          = "1.17"
  depends_on           = [module.aws-vpc]
}

resource "aws_key_pair" "worker_node" {
  key_name   = "billerxchange-kp"
  public_key = "${var.ssh_public_key}"
}
/*
module "eks-services" {
  source = "../terraform-modules/aws-eks-asg"

  project_name         = "billerxchange_ml"
  name                 = "services"
  instance_type        = "t3.micro"
  key_name             = "${aws_key_pair.worker_node.key_name}"
  min_size             = 1
  max_size             = 1
  # spot_price         = "0.450" # Use this for Spot Instance Group
  k8s_version          = module.eks-cluster.eks_version
  subnet_ids           = module.aws-vpc.public_subnets
  eks_b64_ca           = module.eks-cluster.eks_b64_ca
  iam_instance_profile = module.eks-cluster.worker_instance_profile_arn
  security_group_ids   = [module.eks-cluster.worker_sg]
  eks_endpoint         = module.eks-cluster.eks_endpoint

  custom_storage                          = true
  ebs_optimized                           = true
  root_block_device_volume_type           = "gp2"
  root_block_device_volume_size           = 20
  root_block_device_delete_on_termination = true

  depends_on           = [module.eks-cluster]
}
*/
module "eks-node-group" {
  source               = "umotif-public/eks-node-group/aws"
  version              = "~> 3.0.0"
  cluster_name         = "billerxchange_ml"
  subnet_ids           = module.aws-vpc.public_subnets
  desired_size         = 1
  min_size             = 1
  max_size             = 1
  instance_types       = ["t2.xlarge"]
  ec2_ssh_key          = "${aws_key_pair.worker_node.key_name}"
  kubernetes_labels    = {
    lifecycle = "OnDemand"
  }
  force_update_version = true

  depends_on           = [module.eks-cluster]
}