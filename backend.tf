terraform {
  backend "s3" {
    bucket = "tform-jenkins-eks"
    key    = "eks/terraform.tfstate"
    region = var.region
    use_lockfile = true
    encrypt = true
  }
}