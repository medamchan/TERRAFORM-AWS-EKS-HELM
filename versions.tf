terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">= 6.0"
    }
    random = {
        source = "hashicorp/random"
        version = ">= 3.0"
    }
    helm = {
        source = "hashicorp/helm"
        version = ">= 2.0"
    }
  }

}

provider "aws" {
  region = var.region
}

