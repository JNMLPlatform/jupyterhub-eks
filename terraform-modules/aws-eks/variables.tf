
variable "project_name" {
  type    = string
}

variable "vpc_id" {
  type        = string
  description = "VPC id to create ec2 admin instance."
}

variable "subnet_ids" {
  type        = list
  description = "Subnet ids"
}

variable "api_server_whitelist" {
  type        = list
  default     = []
  description = "List of IP to whitelist for api_server."
}

variable "sg_server_whitelist" {
  type        = list
  default     = []
  description = "List of sec groups to whitelist for api_server."
}

variable "enable_public_access" {
  type    = string
  default = true
}

variable "enable_private_access" {
  type    = string
  default = false
}

variable "k8s_version" {
  type = string
  description = "Version of k8s for the eks cluster."
}
