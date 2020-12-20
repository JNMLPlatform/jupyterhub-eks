variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "ssh_public_key" {
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDwVaVrukRvORSxZayhdILlGBxZJ0Jj50Sefhf0U4P7IUM+5v6FhNBzxDwL0raw0nPSQKlLo08eoMqtJa05XIjLBjztIKtcVtDag8WA4WJoIwFPC8FeoBwyxO6b2/NYq2eIjk8DmRIrQktcRjbVYMHQhT+a7r0b65anJnMIpzJtI9EpLh70Kj+trNe+cCTNTgwOhljT1cCFYLkcVTMUKxQlUwyi/3h83hspm32gPnivL+DIlNUB395oNrR027Svg+G6wK+GYNh5+w6evcOoiPr1G8yLEapei9j0ZqXe/TnCvFq4MKh+ReegkbvxnaLmsxd41jIQ0DVAuFzmvOAvTNV block"
}
