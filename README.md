# Terraform AWS EKS Module

***********************************

This Terraform module deploys an Amazon EKS (Elastic Kubernetes Service) cluster on AWS using parameterized input variables.

# Usage
## Prerequisites
Before using this module, ensure you have the following prerequisites:

Terraform installed on your local machine (version >= 0.12).
AWS account and IAM user with appropriate permissions.
AWS CLI configured with access key and secret key.

### Step-by-Step Guide
Follow these steps to deploy an Amazon EKS cluster using this Terraform module:

Clone the RepositoryClone this GitHub repository to your local machine:

git clone https://github.com/your-username/terraform-aws-eks-v2.git
Navigate into the cloned directory:

cd terraform-aws-eks-v2
Update terraform.tfvars: specify values for the parameterized variables based on your requirements.

```bash
Initialize TerraformInitialize Terraform to download providers and modules:  
terraform init

Review Terraform PlanReview the Terraform execution plan to ensure the configuration is correct:  
terraform plan

Apply Terraform ConfigurationApply the Terraform configuration to create the EKS cluster:  
terraform apply --auto-approve
