variable "region" {
    description = "The AWS region to deploy resources in."
    type        = string
}
variable "env" {
    description = "The environment for the deployment (e.g., dev, prod)."
    type        = string
}
variable "vpc_id" {
    description = "The ID of the VPC where resources will be deployed."
    type        = string
}
variable "cluster_name" {
    description = "The name of the EKS cluster."
    type        = string
}
variable "public_subnet" {
    description = "List of public subnet IDs."
    type        = list(string)
}
variable "private_subnet" {
    description = "List of private subnet IDs."
    type        = list(string)
}
variable "vpc_cidr_block" {
    description = "The CIDR block for the VPC."
    type        = string 
}