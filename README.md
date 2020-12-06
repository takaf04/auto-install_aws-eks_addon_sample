# [Sample] AWS EKS & Kubernetes Addon install (using Terraform and Helm)

Automatic installation of AWS EKS and Kubernetes add-ons 

## Using Tool
- Terraform
- Helm
- kubectl

## Installation target
- VPC
- EKS
- Kubernetes Addon
    - Metrics Server
    - aws Calico
    - Cluster Autoscaler

## Usage
1. Modify Terraform Parameter  
    VPC,EKS,add-ons  

2. Run terrafrom  
```
terraform init
terraform plan
terraform apply
```

3. Create kubeconfig  
```
aws eks update-kubeconfig --region us-east-1 --name k8s-addon
```
