# CloudDarkroom

CloudDarkroom is a hands-on AWS project built to deepen my experience with cloud infrastructure, containerization, Infrastructure as Code, and CI/CD automation.
The end goal is to upload an image, resize, store metadata in a PostgreSQL DB, and automatically upload to my different artist sites(instagram, portfolio, etc.)

## What It Does

* Deploys a containerized Python Flask application
* Provisions AWS infrastructure using Terraform
* Stores Terraform state remotely in S3
* Builds and publishes Docker images to Amazon ECR
* Uses GitHub Actions with OIDC authentication to AWS
* Uses Amazon ECS as the container orchestration platform

## Infrastructure

Current AWS resources include:

* VPC
* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* Route Tables
* ECS Cluster
* ECR Repository
* GitHub OIDC Provider
* IAM Roles and Policies

## CI/CD

A GitHub Actions workflow automatically:

1. Triggers on changes to the application
2. Authenticates to AWS using OIDC
3. Builds a Docker image
4. Pushes the image to Amazon ECR

No long-lived AWS credentials are stored in GitHub.

## Current Status

### Completed

* Terraform module structure
* Remote Terraform state
* AWS networking
* ECS cluster
* ECR repository
* Dockerized application
* GitHub Actions pipeline
* OIDC authentication to AWS
* Automated image publishing to ECR

### Next Steps

* ECS Task Definition
* ECS Service
* Application Load Balancer
* Automated ECS deployments
* HTTPS and custom domain


