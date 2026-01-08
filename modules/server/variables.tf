variable "project_name" {
  type        = string
  description = "project name"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "public_key" {
  type        = string
  description = "public key content"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "List of security group ids"
}

variable "subnet_id" {
  type        = string
  description = "subnet id"
}
