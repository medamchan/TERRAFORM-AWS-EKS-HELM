variable "create_eks_cluster_enabled" {
  description = "Flag to enable or disable EKS cluster creation."
  type        = bool
  default     = true
}
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}
variable "kubernetes_version" {
  description = "The Kubernetes version for the EKS cluster."
  type        = string
  default     = "1.21"
}
variable "eks_role_arn" {
  description = "The ARN of the IAM role for the EKS cluster."
  type        = string
}
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster."
  type        = list(string)
}
variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster."
  type        = list(string)
}
variable "endpoint_private_access" {
  description = "Enable private access to the EKS cluster endpoint."
  type        = bool
  default     = true
}
variable "endpoint_public_access" {
  description = "Enable public access to the EKS cluster endpoint."
  type        = bool
  default     = true
}
variable "authentication_mode" {
  description = "The authentication mode for the EKS cluster."
  type        = string
  default     = "AWS_IAM"
}
variable "bootstrap_cluster_creator_admin_permissions" {
  description = "Grant admin permissions to the bootstrap cluster creator."
  type        = bool
  default     = true
}

variable "env" {
    description = "The environment for the deployment (e.g., dev, prod)."
    type        = string 
}

variable "node_group_role_arn" {
  description = "The ARN of the IAM role for EKS node groups."
  type        = string
}

variable "addons" {
  description = "List of EKS addons to be installed."
  type = list(object({
    name    = string
    version = string
  }))
  default = []
  
}

variable "ondemand_node_group_desired_capacity" {
  description = "Desired capacity for the on-demand node group."
  type        = number
  default     = 2
  
}

variable "ondemand_node_group_max_size" {
  description = "Maximum size for the on-demand node group."
  type        = number
  default     = 3
}

variable "ondemand_node_group_min_size" {
  description = "Minimum size for the on-demand node group."
  type        = number
  default     = 1
}

variable "ondemand_instance_types" {
  description = "List of instance types for the on-demand node group."
  type        = list(string)
  default     = ["t3.medium"]
}

variable "spot_node_group_desired_capacity" {
  description = "Desired capacity for the spot node group."
  type        = number
  default     = 2
}

variable "spot_node_group_max_size" {
  description = "Maximum size for the spot node group."
  type        = number
  default     = 3
}

variable "spot_node_group_min_size" {
  description = "Minimum size for the spot node group."
  type        = number
  default     = 1
}

variable "spot_instance_types" {
  description = "List of instance types for the spot node group."
  type        = list(string)
  default     = ["t3.medium", "t3.large"]
}

