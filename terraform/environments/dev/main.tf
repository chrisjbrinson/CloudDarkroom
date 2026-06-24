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
  availability_zone_a = "us-east-1a"

  public_subnet_b_cidr = "10.0.2.0/24"
  availability_zone_b = "us-east-1b"

  private_subnet_a_cidr = "10.0.11.0/24"
  private_subnet_b_cidr = "10.0.12.0/24"

}

module "ecs" {
  source = "../../modules/ecs"

  project_name = "clouddarkroom"
  environment  = "dev"
  container_image = "${module.ecr.repository_url}:latest"
  container_port = 5000
  subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.ecs_security_group_id
  aws_region = "us-east-1"
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = "clouddarkroom"
  environment  = "dev"
}

module "github_oidc" {
  source = "../../modules/github_oidc"

  project_name = "clouddarkroom"
  environment  = "dev"

  github_org  = "chrisjbrinson"
  github_repo = "CloudDarkroom"
}