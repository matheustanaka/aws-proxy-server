variable "public_key" {
  type        = string
  description = "Path to the Public ssh key"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

# Networking vars
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "availability_zone" {
  type        = string
  description = "availability zone"
}
