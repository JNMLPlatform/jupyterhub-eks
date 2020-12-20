locals {
  kubelet-extra-args = "--node-labels=kubelet.kubernetes.io/group=${var.name},kubelet.kubernetes.io/spot-instance=${var.spot_price == "" ? "no" : "yes"}${var.taints=="" ? "" : " --register-with-taints=${var.taints}"}"
}

resource "aws_launch_configuration" "eks" {
  count = var.custom_storage ? 0 : 1

  associate_public_ip_address = true
  iam_instance_profile        = "${var.iam_instance_profile}"
  image_id                    = "${var.eks_worker_ami}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.project_name}-${var.name}-"
  security_groups             = "${var.security_group_ids}"
  spot_price                  = "${var.spot_price}"
  key_name                    = "${var.key_name}"

  user_data = <<USERDATA
                #!/bin/bash
                set -o xtrace
                /etc/eks/bootstrap.sh \
                  --apiserver-endpoint '${var.eks_endpoint}' \
                  --b64-cluster-ca '${var.eks_b64_ca}' \
                  --kubelet-extra-args \
                    ${local.kubelet-extra-args} \
                  '${var.project_name}'
              USERDATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "eks-custom-ebs" {
  count = var.custom_storage ? 1 : 0

  associate_public_ip_address = true
  iam_instance_profile        = "${var.iam_instance_profile}"
  image_id                    = "${var.eks_worker_ami}"
  instance_type               = "${var.instance_type}"
  name_prefix                 = "${var.project_name}-${var.name}-"
  security_groups             = "${var.security_group_ids}"
  spot_price                  = "${var.spot_price}"
  key_name                    = "${var.key_name}"

  ebs_optimized = "${var.ebs_optimized}"
  root_block_device {
    volume_type = "${var.root_block_device_volume_type}"
    volume_size = "${var.root_block_device_volume_size}"
    iops = "${var.root_block_device_iops}"
    delete_on_termination = "${var.root_block_device_delete_on_termination}"
  }

  user_data = <<USERDATA
                #!/bin/bash
                set -o xtrace
                /etc/eks/bootstrap.sh \
                  --apiserver-endpoint '${var.eks_endpoint}' \
                  --b64-cluster-ca '${var.eks_b64_ca}' \
                  --kubelet-extra-args \
                    ${local.kubelet-extra-args} \
                  '${var.project_name}'
              USERDATA

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "eks" {
  name = "${var.project_name}-${var.name}"

  launch_configuration = var.custom_storage ? aws_launch_configuration.eks-custom-ebs[0].id : aws_launch_configuration.eks[0].id
  vpc_zone_identifier = "${var.subnet_ids}"
  min_size = "${var.min_size}"
  max_size = "${var.max_size}"
  enabled_metrics = ["GroupTerminatingInstances", "GroupMaxSize", "GroupDesiredCapacity", "GroupPendingInstances", "GroupInServiceInstances", "GroupMinSize", "GroupTotalInstances", "GroupStandbyInstances"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key = "Name"
    value = "${var.project_name}-${var.name}"
    propagate_at_launch = true
  }

  tag {
    key = "Cluster"
    value = "${var.project_name}"
    propagate_at_launch = true
  }
  
  tag {
    key = "eks:cluster-name"
    value = var.project_name
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.project_name}"
    value = "owned"
    propagate_at_launch = true
  }

  tag {
    key = "k8s.io/role/node"
    value = "1"
    propagate_at_launch = true
  }

  tag {
    key = "kubelet.kubernetes.io/group"
    value = "${var.name}"
    propagate_at_launch = true
  }

  tag {
    key = "beta.kubernetes.io/instance-type"
    value = "${var.instance_type}"
    propagate_at_launch = true
  }

  tag {
    key = "instance-group"
    value = "${var.name}"
    propagate_at_launch = true
  }

  # for k8s autoscaler addon auto-discovery
  # see https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler/cloudprovider/aws
  tag {
    key = "k8s.io/cluster-autoscaler/enabled"
    value = "true"
    propagate_at_launch = true
  }

  # https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-autoscaler-setup/
  tag {
    key = "k8s.io/cluster-autoscaler/${var.project_name}"
    value = "owned"
    propagate_at_launch = true
  }

}
