variable "vpc_id" {}

variable "public_subnet_ids" {}

variable "private_subnet_ids" {}

variable "vpc_cidr" {}
variable "dns_hostnames" {}
variable "dns_support" {}
variable "pub_one_cidr" {}
variable "pub_two_cidr" {}
variable "priv_one_cidr" {}
variable "priv_two_cidr" {}


variable "cluster_name" {
  type    = string
  description = "Name of the EKS cluster"
}

# Variable for EKS Cluster Version
variable "eks_version" {
    type = string
    description = "EKS Version"
}

# Variable for worker nodes desired capacity

variable "desired_size" {
  description = "The desired number of worker nodes."
  type        = number
  default     = 2
}
# Variable for worker nodes min size
variable "min_size" {
  description = "The minimum number of worker nodes."
  type        = number
  default     = 1
}

# variable for Worker nodes max size
variable "max_size" {
  description = "The maximum number of worker nodes."
  type        = number
  default     = 8
}

# variable for worker nodes ami type
variable "ami_type" {
    type = string
    description = "AMI type for your worker nodes"
}

# variable for instance types
variable "instance_types" {
  type    = list(string)
  default = ["t3.small", "t3.medium", "t3.large"]
}

# Variable for worker nodes capacity type
variable "capacity_type" {
 type = string
 description = "a variable for your worker nodes capacity type"
}

# Variable disk size for Worker Nodes
variable "disk_size" {
    type = string
    description = "Disk size for your Worker Nodes"
    default = "50"
}


# variable for max unavailable nodes
variable "max_unavailable" {
  type = string
  description = "max unavailable nodes for your worker nodes"
  default = 1
}
 


