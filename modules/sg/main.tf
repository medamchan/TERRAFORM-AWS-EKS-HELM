resource "aws_security_group" "eks-cluster-sg"{
  name        = "eks-cluster-sg-${var.env}-${terraform.workspace}"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
  ingress = [
    {
      description      = "Allow all HTTPS traffic"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      self             = true
      security_groups = [aws_security_group.bastion-sg.id]
    }
  ]
  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name        = "eks-cluster-sg-${var.env}-${terraform.workspace}"
    environment = "${var.env}-${terraform.workspace}"
  }
}

resource "aws_security_group" "bastion-sg" {
  name        = "bastion-sg-${var.env}-${terraform.workspace}"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress = [
    {
      description      = "Allow SSH access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]
  egress = [
    {
      description      = "Allow all outbound traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
    }
  ]

  tags = {
    Name        = "bastion-sg-${var.env}-${terraform.workspace}"
    environment = "${var.env}-${terraform.workspace}"
  }
}