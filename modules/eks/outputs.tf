output "cluster_endpoint" {
    description = "The endpoint for the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].endpoint
}
output "cluster_certificate_authority_data" {
    description = "The certificate authority data for the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].certificate_authority[0].data
}
output "cluster_name" {
    description = "The name of the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].name
}
output "cluster_arn" {
    description = "The ARN of the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].arn
}
output "cluster_id" {
    description = "The ID of the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].id
}
output "node_group_names" {
    description = "List of EKS node group names."
    value       = aws_eks_node_group.eks_node_group[*].node_group_name
}

output "node_group_arns" {
    description = "List of EKS node group ARNs."
    value       = aws_eks_node_group.eks_node_group[*].arn
}

output "oidc_provider_url" {
    description = "The OIDC provider URL for the EKS cluster."
    value       = aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
    description = "The ARN of the OIDC provider for the EKS cluster."
    value       = aws_iam_openid_connect_provider.eks_cluster_oidc.arn
}

output "addon_names" {
    description = "List of EKS addon names."
    value       = aws_eks_addon.eks_cluster_addons[*].addon_name
}

output "addon_arns" {
    description = "List of EKS addon ARNs."
    value       = aws_eks_addon.eks_cluster_addons[*].arn
}

