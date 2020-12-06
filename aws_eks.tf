# EKS
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = var.param.eks.cluster.name
  cluster_version = var.param.eks.cluster.version
  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.private_subnets
  enable_irsa     = true

  cluster_endpoint_public_access       = var.param.eks.cluster_endpoint.endpoint_public_access
  cluster_endpoint_public_access_cidrs = var.param.eks.cluster_endpoint.public_access_cidrs
  cluster_endpoint_private_access      = true

  worker_groups = [
    {
      name                = var.param.eks.worker_node.group_name
      instance_type       = var.param.eks.worker_node.instance_type
      root_volume_size    = var.param.eks.worker_node.root_block_device.volume_size
      root_volume_type    = var.param.eks.worker_node.root_block_device.volume_type

      asg_desired_capacity = var.param.eks.worker_node.node_count.desired_capacity
      asg_max_size         = var.param.eks.worker_node.node_count.max_size
      asg_min_size         = var.param.eks.worker_node.node_count.min_size

      tags = [
        # Cluster Autoscaler Setting
        {
          "key"                 = "k8s.io/cluster-autoscaler/enabled"
          "propagate_at_launch" = "false"
          "value"               = "true"
        },
        {
          "key"                 = "k8s.io/cluster-autoscaler/${var.param.eks.cluster.name}"
          "propagate_at_launch" = "false"
          "value"               = "true"
        }
      ]
    }
  ]
  workers_additional_policies = [
    # CloudWatch Container Insights
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  ]
  map_accounts = var.param.eks.map_accounts
  map_roles    = var.param.eks.auth.map_roles
  map_users    = var.param.eks.auth.map_users
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
