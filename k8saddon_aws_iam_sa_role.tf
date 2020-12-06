# k8sアドオン用 IAM Role作成

# [参考]Terrraform Registry Module
# https://github.com/terraform-aws-modules/terraform-aws-eks/tree/master/examples/irsa


# Cluster Autoscaler
# https://docs.aws.amazon.com/ja_jp/eks/latest/userguide/cluster-autoscaler.html

# IAM Service Account Role  [Cluster Autoscaler] 
module "iam_role_sa_cluster_autoscaler" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "~> v2.14.0"
  create_role                   = true
  role_name                     = "${module.eks.cluster_id}_cluster-autoscaler"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.cluster_autoscaler.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:cluster-autoscaler-aws-cluster-autoscaler"]
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name_prefix = "${module.eks.cluster_id}_cluster-autoscaler"
  description = "EKS cluster-autoscaler policy for cluster ${module.eks.cluster_id}"
  policy      = file("./policy_json/cluster_autoscaler.json")
}
