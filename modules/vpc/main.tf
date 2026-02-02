resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy = "default"
    tags = {
        Name = "vpc-${var.env}-${terraform.workspace}"
        environment = "${var.env}-${terraform.workspace}"
    }

}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = true
        tags = {
            Name = "public-subnet-${var.env}-${terraform.workspace}-${data.aws_availability_zones.available.names[count.index]}"
            environment = "${var.env}-${terraform.workspace}"
            "kubernetes.io/cluster/${var.cluster_name}" = "owned"
            "kubernetes.io/role/elb"                    = "1" # For internet facing ALB
        }
    depends_on = [ aws_vpc.main ]
}

resource "aws_subnet" "private_subnet" {
    count = length(data.aws_availability_zones.available.names)
    vpc_id            = aws_vpc.main.id
    cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + length(data.aws_availability_zones.available.names))
    availability_zone = data.aws_availability_zones.available.names[count.index]
    map_public_ip_on_launch = false
        tags = {
            Name = "private-subnet-${var.env}-${terraform.workspace}-${data.aws_availability_zones.available.names[count.index]}"
            environment = "${var.env}-${terraform.workspace}"
            "kubernetes.io/cluster/${var.cluster_name}" = "owned"
            "kubernetes.io/role/elb"                    = "1" # For internal facing ALB
        }
    depends_on = [ aws_vpc.main ]
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
        tags = {
            Name = "igw-${var.env}-${terraform.workspace}"
            environment = "${var.env}-${terraform.workspace}"
            "kubernetes.io/cluster/${var.cluster_name}" = "owned"
        }
    depends_on = [ aws_vpc.main ]
}

resource "aws_eip" "nat_eip" {
    count = length(data.aws_availability_zones.available.names)
    domain = vpc
        tags = {
            Name = "nat-eip-${var.env}-${terraform.workspace}-${data.aws_availability_zones.available.names[count.index]}"
            environment = "${var.env}-${terraform.workspace}"
        }
    depends_on = [ aws_vpc.main ]
}

resource "aws_nat_gateway" "nat_gw" {
    count = length(data.aws_availability_zones.available.names)
    subnet_id = aws_subnet.public_subnet[count.index].id
        tags = {
            Name = "nat-gw-${var.env}-${terraform.workspace}-${data.aws_availability_zones.available.names[count.index]}"
            environment = "${var.env}-${terraform.workspace}"
        }
    depends_on = [ aws_vpc.main, aws_subnet.public_subnet[count.index] ]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt-${var.env}-${terraform.workspace}"
    environment = "${var.env}-${terraform.workspace}"
  }
  depends_on = [ aws_vpc.main ]
}

resource "aws_route_table_association" "public_rt_assoc" {
    count = length(aws_subnet.public_subnet)
    subnet_id      = aws_subnet.public_subnet[count.index].id
    route_table_id = aws_route_table.public_rt.id

    depends_on = [ aws_vpc.main, aws_subnet.public_subnet ]
}

resource "aws_route_table" "priavate_rt" {
    vpc_id = aws_vpc.main
    tags = {
        Name = "private-rt-${var.env}-${terraform.workspace}"
        environment = "${var.env}-${terraform.workspace}"
    }
    depends_on = [ aws_vpc.main ]
}

resource "aws_route_table_association" "private_rt_assoc" {
    count = length(aws_subnet.private_subnet)
    subnet_id      = aws_subnet.private_subnet[count.index].id
    route_table_id = aws_route_table.priavate_rt.id
    depends_on = [ aws_vpc.main, aws_subnet.private_subnet ]
}

