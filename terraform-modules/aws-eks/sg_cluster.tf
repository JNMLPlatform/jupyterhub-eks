
resource "aws_security_group" "cluster" {
  name        = "${var.project_name}-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "outcome requests"
  }

  tags = {
    Name       = "${var.project_name}-cluster"
    Cluster = "${var.project_name}"
    "kubernetes.io/cluster/${var.project_name}" = "owned"
  }
}

resource "aws_security_group_rule" "cluster-ingress-pods" {
  description              = "Allow pods to communicate with the cluster API Server"
  security_group_id        = "${aws_security_group.cluster.id}"

  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  source_security_group_id = "${aws_security_group.node.id}"
}