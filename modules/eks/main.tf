resource "aws_eks_cluster" "eks_cluster" {
  
  count = var.create_eks_cluster_enabled == true ? 1 : 0
  name     = var.cluster_name
  version  = var.kubernetes_version
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = var.security_group_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access

  }

  access_config {
    authentication_mode = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_cluster_creator_admin_permissions
  }

    tags = {
        Name        = "${var.cluster_name}-${var.env}-${terraform.workspace}"
        environment = "${var.env}-${terraform.workspace}"
    }
}

data "tls_certificate" "eks_certificate" {
    url   = aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_cluster_oidc" {
    client_id_list  = ["sts.amazonaws.com"]
    thumbprint_list = [data.tls_certificate.eks_certificate.certificates[0].sha1_fingerprint]
    url             = aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer
}

resource "aws_eks_addon" "eks_cluster_addons" {

    for_each = { for idx, addon in var.addons : idx => addon }
    cluster_name = aws_eks_cluster.eks_cluster[0].name
    addon_name   = each.value.name
    addon_version = each.value.version

    depends_on = [ aws_eks_node_group.ondemand-node, aws_eks_node_group.spot-node ]
  
}

resource "aws_eks_node_group" "ondemand-node" {
    cluster_name    = aws_eks_cluster.eks_cluster[0].name
    node_group_name = "${var.cluster_name}-ondemand-${var.env}-${terraform.workspace}"
    node_role_arn   = var.node_group_role_arn
    subnet_ids      = var.subnet_ids
    scaling_config {
        desired_size = var.ondemand_node_group_desired_capacity
        max_size     = var.ondemand_node_group_max_size
        min_size     = var.ondemand_node_group_min_size
    }

    instance_types = var.ondemand_instance_types
    capacity_type   = "ON_DEMAND"
    labels = {
      "type" = "ondemand" 
    }
    update_config {
      max_unavailable = 1
    }

    tags = {
        Name        = "${var.cluster_name}-ondemand-${var.env}-${terraform.workspace}"
        environment = "${var.env}-${terraform.workspace}"
    }
    tags_all = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      Name        = "${var.cluster_name}-ondemand-${var.env}-${terraform.workspace}"
      environment = "${var.env}-${terraform.workspace}"
    }

    depends_on = [ aws_eks_cluster.eks_cluster ]
  
}

resource "aws_eks_node_group" "spot-node" {
    cluster_name    = aws_eks_cluster.eks_cluster[0].name
    node_group_name = "${var.cluster_name}-spot-${var.env}-${terraform.workspace}"
    node_role_arn   = var.node_group_role_arn
    subnet_ids      = var.subnet_ids
    scaling_config {
        desired_size = var.spot_node_group_desired_capacity
        max_size     = var.spot_node_group_max_size
        min_size     = var.spot_node_group_min_size
    }

    instance_types = var.spot_instance_types
    capacity_type   = "SPOT"
    labels = {
      "type" = "spot"
      "lifecycle" = "spot"
    }
    update_config {
      max_unavailable = 1
    }

    tags = {
        Name        = "${var.cluster_name}-spot-${var.env}-${terraform.workspace}"
        environment = "${var.env}-${terraform.workspace}"
    }
    tags_all = {
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
      Name        = "${var.cluster_name}-spot-${var.env}-${terraform.workspace}"
      environment = "${var.env}-${terraform.workspace}"
    }
    disk_size = 50

    depends_on = [ aws_eks_cluster.eks_cluster ]
  
}