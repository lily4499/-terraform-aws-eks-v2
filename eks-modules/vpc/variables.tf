
# Variable for your VPC_ID
variable "vpc_id" {
    type = string
}


# Variable for vpc cidr
variable "vpc_cidr" {
  type = string
  description = "Variable for your vpc cidr block"

}

# Create a variable for your vpc dns support
variable "dns_support" {
    type = string
   description = "This is a variable for your dns support"
}

# Variable for DNS hostnames
variable "dns_hostnames" {
   type = string
   description = "This is a variable for my vpc hostnames"
}

# Variable for vpc tags
variable "vpc_tags" {
  type = map(string)
  description = "This is the variable for my vpc tags"
  default = {
    Name        = "main_vpc"
    Environment = "Production"
    Team        = "DevOps"
  }
}

# Variable for IGW
variable "igw_tags" {
  type = map(string)
  default = {
    Name        = "vpc_igw"
    Environment = "Production"
    Team        = "DevOps"
  }
}

# variable for public subnet one cidr
variable "pub_one_cidr" {
   type = string
   description = "cidr for first public subnet"
}

# variable for public subnet two cidr 

variable "pub_two_cidr" {
   type = string
   description = "cidr for second public subnet"
}

# Varible for private subnet one cidr
 variable "priv_one_cidr" {
   type = string
   description = "cidr for first private subnet" 
}

# Variable for private subnet twp cidr
 variable "priv_two_cidr" {
  type = string
  description = "cidr for second private subnet"
}

# Variable for public ip on launch for Public subnets
variable "public_ip_launch" {
     type = string
     default = true
}





