module "network" {
  source = "../../modules/network"

  project_name = var.project_name
  environment  = var.environment

  vpc_cidr = var.vpc_cidr

  public_subnet_a_cidr = var.public_subnet_a_cidr
  availability_zone_a  = var.availability_zone_a

  public_subnet_b_cidr = var.public_subnet_b_cidr
  availability_zone_b  = var.availability_zone_b

  private_subnet_a_cidr = var.private_subnet_a_cidr
  private_subnet_b_cidr = var.private_subnet_b_cidr

}

module "ecs" {
  source = "../../modules/ecs"

  project_name      = var.project_name
  environment       = var.environment
  container_image   = "${module.ecr.repository_url}:latest"
  container_port    = 5000
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.network.ecs_security_group_id
  aws_region        = var.aws_region

  upload_bucket_name = module.s3.bucket_name
  processed_bucket_name = module.processed_bucket.bucket_name
}

module "ecr" {
  source = "../../modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

module "github_oidc" {
  source = "../../modules/github_oidc"

  project_name = var.project_name
  environment  = var.environment

  github_org  = var.github_org
  github_repo = var.github_repo
}

module "s3" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  bucket_suffix = "uploads"
  lambda_function_arn = module.lambda.function_arn
  lambda_function_name = module.lambda.function_name
}

module "processed_bucket" {
  source = "../../modules/s3"

  project_name = var.project_name
  environment  = var.environment
  bucket_suffix = "processed"
}

module "artifacts_bucket" {
  source = "../../modules/s3"

  project_name  = var.project_name
  environment   = var.environment
  bucket_suffix = "artifacts"
}

module "lambda" {
  source = "../../modules/lambda"

  project_name = var.project_name
  environment  = var.environment
  upload_bucket_name    = module.s3.bucket_name
  processed_bucket_name = module.processed_bucket.bucket_name
}