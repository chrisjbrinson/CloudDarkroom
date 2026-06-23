# CloudDarkroom

CloudDarkroom is an event-driven image processing platform built on AWS.

## Planned Architecture

- S3 for image storage
- Lambda for image processing
- PostgreSQL for metadata
- Terraform for infrastructure
- GitHub Actions for CI/CD

## Workflow

Upload Image
→ S3
→ Lambda Trigger
→ Thumbnail Generation
→ Metadata Storage