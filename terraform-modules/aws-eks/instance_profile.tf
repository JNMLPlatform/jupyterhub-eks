resource "aws_iam_instance_profile" "node" {
  name = "${var.project_name}-node"
  role = "${aws_iam_role.node.name}"  
}
