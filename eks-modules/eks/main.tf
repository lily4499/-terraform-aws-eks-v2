# Create an IAM role for the EKS cluster

resource "aws_iam_role" "eks_cluster_role" {
  name = "lili_eks_cluster_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_cluster_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Create an IAM role for the worker nodes

resource "aws_iam_role" "eks_worker_node_role" {
  name = "lili_eks_worker_node_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach the necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_ec2CR_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_node_role.name
}


module "vpc" {
  source         = "../vpc"  # Path to your VPC module directory
  vpc_id         = module.vpc.vpc_id
  vpc_cidr       = var.vpc_cidr
  dns_hostnames  = var.dns_hostnames
  dns_support    = var.dns_support
  pub_one_cidr   = var.pub_one_cidr
  pub_two_cidr   = var.pub_two_cidr
  priv_one_cidr  = var.priv_one_cidr
  priv_two_cidr  = var.priv_two_cidr

  # Calculate CIDR blocks dynamically using cidrsubnet
  # pub_subnets = [
  #  {
  #    name         = "PublicSubnet-1"
  #    cidr_block   = cidrsubnet(var.vpc_cidr, 8, 0)  # CIDR block for first public subnet (10.0.0.0/24)
  #    type         = "Public"
  #  },
  #  {
  #    name         = "PublicSubnet-2"
  #    cidr_block   = cidrsubnet(var.vpc_cidr, 8, 1)  # CIDR block for second public subnet (10.0.1.0/24)
  #    type         = "Public"
  #  }
  #]

  #priv_subnets = [
  #  {
  #    name         = "PrivateSubnet-1"
  #    cidr_block   = cidrsubnet(var.vpc_cidr, 8, 2)  # CIDR block for first private subnet (10.0.2.0/24)
  #    type         = "Private"
  #  },
  #  {
  #    name         = "PrivateSubnet-2"
  #    cidr_block   = cidrsubnet(var.vpc_cidr, 8, 3)  # CIDR block for second private subnet (10.0.3.0/24)
  #    type         = "Private"
  #  }
  #]

}


# Create an EKS cluster
resource "aws_eks_cluster" "lili_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
  #  subnet_ids = concat(var.private_subnet_ids, var.public_subnet_ids)
  #  subnet_ids = module.vpc.private_subnet_ids  # Reference private subnet IDs
    subnet_ids = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_role_attachment
  ]
}


# Create the EKS node group
resource "aws_eks_node_group" "eks_node" {
  cluster_name    = aws_eks_cluster.lili_cluster.name
  node_group_name = "eks_node"
  node_role_arn   =  aws_iam_role.eks_worker_node_role.arn

  # Subnet configuration
  subnet_ids = module.vpc.private_subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }


  update_config {
    max_unavailable = 1
  }


  # Use the latest EKS-optimized Amazon Linux 2 AMI
  ami_type = var.ami_type

 
  # Configure the node group instances
  instance_types = var.instance_types


  # Use the managed node group capacity provider
  capacity_type = var.capacity_type



  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.

  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy_attachment,
    aws_iam_role_policy_attachment.eks_cni_policy_attachment,
    aws_iam_role_policy_attachment.eks_ec2CR_policy_attachment,
  ]
}
