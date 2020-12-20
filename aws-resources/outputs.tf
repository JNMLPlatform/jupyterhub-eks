
output "eks_version" {
  value = "${module.eks-cluster.eks_version}"
}

output "eks_arn" {
  value       = "${module.eks-cluster.eks_arn}"
  description = "ARN for the EKS cluster."
}

output "eks_endpoint" {
  value       = "${module.eks-cluster.eks_endpoint}"
  description = "EKS api server endpoint."
}

output "eks_b64_ca" {
  value       = "${module.eks-cluster.eks_b64_ca}"
  description = "Base64 encode CA for the EKS api server."
}

output "config_map_aws_auth" {
  value       = "${module.eks-cluster.config_map_aws_auth}"
  description = "Config map required for worker nodes to join the cluster. Please generate this configmap and apply to the cluster with kubectl."
}

output "kubeconfig" {
  value       = "${module.eks-cluster.kubeconfig}"
  description = "Kubectl config to connect to the cluster. Requires AWS IAM authenticator. (See https://docs.aws.amazon.com/eks/latest/userguide/install-aws-iam-authenticator.html)"
}

output "cluster_iam_arn" {
  value       = "${module.eks-cluster.cluster_iam_arn}"
  description = "ARN for the cluster master nodes IAM role."
}

output "cluster_iam_name" {
  value       = "${module.eks-cluster.cluster_iam_name}"
  description = "Name for the cluster master nodes IAM role."
}

output "cluster_sg" {
  value       = "${module.eks-cluster.cluster_sg}"
  description = "Security group id for cluster master nodes."
}

output "worker_iam_arn" {
  value       = "${module.eks-cluster.worker_iam_arn}"
  description = "ARN for the cluster worker nodes IAM role."
}

output "worker_iam_name" {
  value       = "${module.eks-cluster.worker_iam_name}"
  description = "Name for the cluster worker nodes IAM role."
}

output "worker_instance_profile_name" {
  value       = "${module.eks-cluster.worker_instance_profile_name}"
  description = "Name for the cluster worker instance profile."
}

output "worker_instance_profile_arn" {
  value       = "${module.eks-cluster.worker_instance_profile_arn}"
  description = "Worker instance profile ARN"
}

output "worker_sg" {
  value       = "${module.eks-cluster.worker_sg}"
  description = "Security group id for cluster worker nodes."
}