variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    type        = string 
}
variable "env" {
    description = "The environment for the deployment (e.g., dev, prod)."
    type        = string 
}
variable "public_subnet" {
  type = list(string)
}
variable "private_subnet" {
  type = list(string)
}
variable"cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}
