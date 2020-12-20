#
# Outputs
#

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.eks.endpoint}
    certificate-authority-data: ${aws_eks_cluster.eks.certificate_authority.0.data}
  name: ${var.project_name}
contexts:
- context:
    cluster: ${var.project_name}
    user: ${var.project_name}
  name: ${var.project_name}
current-context: ${var.project_name}
kind: Config
preferences: {}
users:
- name: ${var.project_name}
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.project_name}"
KUBECONFIG
}

output "eks_version" {
  value       = "${aws_eks_cluster.eks.version}"
  description = "EKS version"
}

output "eks_arn" {
  value       = "${aws_eks_cluster.eks.arn}"
  description = "ARN for the EKS cluster."
}

output "eks_endpoint" {
  value       = "${aws_eks_cluster.eks.endpoint}"
  description = "EKS api server endpoint."
}

output "eks_b64_ca" {
  value       = "${aws_eks_cluster.eks.certificate_authority.0.data}"
  description = "Base64 encode CA for the EKS api server."
}

output "config_map_aws_auth" {
  value       = "${local.config_map_aws_auth}"
  description = "Config map required for worker nodes to join the cluster. Please generate this configmap and apply to the cluster with kubectl."
}

output "kubeconfig" {
  value       = "${local.kubeconfig}"
  description = "Kubectl config to connect to the cluster. Requires AWS IAM authenticator. (See https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)"
}

output "cluster_iam_arn" {
  value       = "${aws_iam_role.cluster.arn}"
  description = "ARN for the cluster master nodes IAM role."
}

output "cluster_iam_name" {
  value       = "${aws_iam_role.node.name}"
  description = "Name for the cluster master nodes IAM role."
}

output "cluster_sg" {
  value       = "${aws_security_group.cluster.id}"
  description = "Security group id for cluster master nodes."
}

output "worker_iam_arn" {
  value       = "${aws_iam_role.node.arn}"
  description = "ARN for the cluster worker nodes IAM role."
}

output "worker_iam_name" {
  value       = "${aws_iam_role.node.name}"
  description = "Name for the cluster worker nodes IAM role."
}

output "worker_instance_profile_name" {
  value       = "${aws_iam_instance_profile.node.name}"
  description = "Name for the cluster worker instance profile."
}

output "worker_instance_profile_arn" {
  value       = "${aws_iam_instance_profile.node.arn}"
  description = "worker instance profile arn"
}

output "worker_sg" {
  value       = "${aws_security_group.node.id}"
  description = "Security group id for cluster worker nodes."
}
