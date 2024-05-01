variable "region" {}

# Define required variables
variable "cluster_name" {
  type    = string
  # Optionally specify a description or default value
  # description = "Name of the EKS cluster"
  default     = "my-cluster"
}

variable "eks_version" {
  description = "Version of EKS"
}

variable "instance_types" {}
variable "capacity_type" {}
variable "ami_type" {}

variable "vpc_cidr" {}
variable "dns_hostnames" {}
variable "dns_support" {}
variable "pub_one_cidr" {}
variable "pub_two_cidr" {}
variable "priv_one_cidr" {}
variable "priv_two_cidr" {}








