resource "aws_eks_cluster" "eks" {
  name     = "${var.project_name}"
  role_arn = "${aws_iam_role.cluster.arn}"

  version                   = "${var.k8s_version}"

  vpc_config {
    security_group_ids      = ["${aws_security_group.cluster.id}"]
    subnet_ids              = "${var.subnet_ids}"
    endpoint_private_access = "${var.enable_private_access}"
    endpoint_public_access  = "${var.enable_public_access}"
  }

  depends_on = [
    "aws_iam_role_policy_attachment.cluster-AmazonEKSClusterPolicy"
  ]
}
