terraform {
  # Run init/plan/apply with "backend" commented-out (ueses local backend) to provision Resources (Bucket, Table)
  # Then uncomment "backend" and run init, apply after Resources have been created (uses AWS)
  backend "s3" {
    bucket         = "dhx-tf-state"
    key            = "tf-infra/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_version = ">=0.13.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.29"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "tf-state" {
  source      = "./modules/tf-state"
  bucket_name = "dhx-tf-state"
}


module "lb_nginx" {
  source = "./modules/lb_nginx"
}

output "loadbalanced_nginx_outputs" {
  value = module.lb_nginx
}