terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "clouddarkroom-brinson-tfstate"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../modules/network"

  project_name = "clouddarkroom"
  environment  = "dev"

  vpc_cidr = "10.0.0.0/16"

  public_subnet_a_cidr = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  public_subnet_b_cidr = "10.0.2.0/24"
  availability_zone_b = "us-east-1b"

  private_subnet_a_cidr = "10.0.11.0/24"
  private_subnet_b_cidr = "10.0.12.0/24"

}