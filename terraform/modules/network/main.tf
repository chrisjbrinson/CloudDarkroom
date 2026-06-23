resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-vpc"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_a_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-a"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "${var.project_name}-${var.environment}-igw"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-public-rt"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_b_cidr
  availability_zone       = var.availability_zone_b
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-b"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_a_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-a"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_b_cidr
  availability_zone = var.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-b"
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}