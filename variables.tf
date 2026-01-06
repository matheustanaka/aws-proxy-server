variable "public_key" {
  type        = string
  description = "Path to the Public ssh key"
}

variable "region" {
  type        = string
  description = "Path to the Public ssh key"
}

variable "project_name" {
  type        = string
  description = "Project name"
}

# Networking vars
variable "vpc_cidr" {
  type        = string
  description = "Project name"
}

variable "availability_zone" {
  type        = string
  description = "Project name"
}
