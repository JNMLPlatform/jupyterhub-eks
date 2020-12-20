variable "project_name" {
  type = string
}

variable "name" {
  type        = string
  description = "Instance group name (must be unique for each eks)."
}

variable "k8s_version" {
  type        = string
  default     = "1.17"
  description = "Version of kubernetes to create."
}

variable "iam_instance_profile" {
  type        = string
  description = "Name of the eks worker node instance profile. (default: <project_name>-node)"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type. e.g. m4.2xlarge"
}

variable "security_group_ids" {
  type        = list
  description = "List of security group ids for the nodes in the instance group."
}

variable "subnet_ids" {
  type = list
  description = "subnet id (list)"
}

variable "key_name" {
  type        = string
  default     = ""
  description = "Name of the ssh key for the ec2 instance."
}

variable "spot_price" {
  type        = string
  default     = ""
  description = "If provided, use spot instances instead."
}

variable "eks_endpoint" {
  type        = string
  description = "EKS endpoint."
}

variable "eks_b64_ca" {
  type        = string
  description = "Base64 encoded CA for EKS, i.e. `aws_eks_cluster.eks.certificate_authority.0.data`."
}

variable "min_size" {
  type        = string
  default     = 1
  description = "Min number of nodes in instance group"
}

variable "max_size" {
  type        = string
  default     = 1
  description = "Max number of nodes in instance group"
}

variable "eks_worker_ami" {
  type        = string
  default     = "ami-07250434f8a7bc5f1"
  description = "Worker AMI ID"
}

variable "custom_storage" {
  type        = string
  default     = false
}

variable "ebs_optimized" {
  type        = string
  default     = true
}

variable "root_block_device_volume_type" {
  type        = string
  default     = "gp2"
}

variable "root_block_device_volume_size" {
  type        = string
  default     = 20
}

variable "root_block_device_iops" {
  type        = string
  default     = 0
  description = "https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-io-characteristics.html"
}

variable "root_block_device_delete_on_termination" {
  type        = string
  default     = true
}

variable "taints" {
  type        = string
  default     = ""
  description = "Register taints for the nodes. e.g. key=value:NoSchedule"
}