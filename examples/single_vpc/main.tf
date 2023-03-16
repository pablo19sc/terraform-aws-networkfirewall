# --- examples/single_vpc/main.tf ---

# VPC (from local module)
module "vpc" {
  source = "./modules/vpc"

  identifier = var.identifier
  cidr_block = var.vpc.cidr_block
  number_azs = var.vpc.number_azs
  subnet_cidr_blocks = {
    firewall  = var.vpc.firewall_subnet_cidrs
    protected = var.vpc.protected_subnet_cidrs
    private   = var.vpc.private_subnet_cidrs
  }
}

# Logging Resources
resource "aws_s3_bucket" "logs" {
  bucket_prefix = "anfw-logging-bucket"
  acl           = "private"

  versioning {
    enabled = true
  }
  force_destroy = true
}

resource "aws_cloudwatch_log_group" "anfw_logs" {
  name = "ANFWLogs"
}

# AWS Network Firewall
module "network_firewall" {
  source  = "aws-ia/networkfirewall/aws"
  version = "0.0.2"

  network_firewall_name   = "anfw-${var.identifier}"
  network_firewall_policy = aws_networkfirewall_firewall_policy.anfw_policy.arn

  vpc_id      = module.vpc.vpc_id
  number_azs  = var.vpc.number_azs
  vpc_subnets = module.vpc.subnet_ids.firewall

  routing_configuration = {
    single_vpc = {
      igw_route_table               = module.vpc.route_table_ids.igw
      protected_subnet_route_tables = module.vpc.route_table_ids.protected
      protected_subnet_cidr_blocks  = module.vpc.subnet_cidrs.protected
    }
  }

  logging_configuration = {
    flow_log_destination = {
      s3_bucket = {
        bucketName = aws_s3_bucket.logs.id
        logPrefix  = "logs"
      }
    }
    alert_log_destination = {
      cloudwatch_logs = {
        logGroupName = aws_cloudwatch_log_group.anfw_logs.name
      }
    }
  }
}


