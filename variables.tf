variable "param" {
  default = {
    # regin
    region = "us-east-1"

    # VPC
    vpc = {
      vpc_name                  = "k8s-addon"
      vpc_cidr_block            = "172.16.0.0/16"
      public_subnet_cidr_block  = ["172.16.0.0/20", "172.16.16.0/20", "172.16.32.0/20"]
      private_subnet_cidr_block = ["172.16.144.0/20", "172.16.160.0/20", "172.16.176.0/20"]
    }
    # EKS
    eks = {
      map_accounts = [
        000000000000
      ]
      cluster = {
        name                      = "k8s-addon"
        version                   = "1.18"
        cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
      }
      cluster_endpoint = {
        endpoint_public_access = true
        public_access_cidrs    = ["111.111.111.111/32"]
      }
      worker_node = {
        group_name    = "k8s-addon-worker-group-1"
        instance_type = "t3.large"
        node_count = {
          desired_capacity = 1
          max_size         = 3
          min_size         = 1
        }
        root_block_device = {
          volume_type = "gp2"
          volume_size = "50"
        }
      }
      auth = {
        map_users = [
          {
            userarn  = "arn:aws:iam::00000000000:user/user1"
            username = "user1"
            groups   = ["system:masters"]
          }
        ]
        map_roles = [
          {
            rolearn  = "arn:aws:iam::00000000000:role/role1"
            username = "role1"
            groups   = ["system:masters"]
          }
        ]
      }
    }

    # kubernetes Addon (Helm)
    k8saddon = {
      metrics_server = {
        version = "2.11.2"
      }
      aws_calico = {
        version = "0.3.4"
      }
      cluster_autoscaler = {
        version = "9.2.0"
      }
    }
  }
}
