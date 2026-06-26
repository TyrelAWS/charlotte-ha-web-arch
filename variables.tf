variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "Primary AWS region for deployment"
}

variable "project_name" {
  type        = string
  default     = "clt-enterprise-web"
  description = "Value for naming tags"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Base CIDR block for the custom VPC"
}