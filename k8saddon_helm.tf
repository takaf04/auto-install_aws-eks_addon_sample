# Kubernetesアドオンインストール
# Metrics Server
# https://artifacthub.io/packages/helm/metrics-server/metrics-server
resource "helm_release" "metrics-server" {
  name       = "kubernetes-metrics-server"
  repository = "https://olemarkus.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"
  version    = var.param.k8saddon.metrics_server.version
}


# aws-calico
# https://artifacthub.io/packages/helm/aws/aws-calico
resource "helm_release" "aws-calico" {
  name       = "aws-calico"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-calico"
  namespace  = "kube-system"
  version    = var.param.k8saddon.aws_calico.version
}

# Cluster Autoscaler
# https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler
resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"
  version    = var.param.k8saddon.cluster_autoscaler.version
  set {
    name  = "autoDiscovery.clusterName"
    value = data.aws_eks_cluster.cluster.id
  }
  set {
    name  = "awsRegion"
    value = var.param.region
  }
  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_role_sa_cluster_autoscaler.this_iam_role_arn
  }
}
