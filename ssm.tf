resource "random_password" "auth" {
  count       = (var.encryption == true) ? 1 : 0
  length      = 64
  special     = false
  min_upper   = 12
  min_lower   = 12
  min_numeric = 12
}

resource "aws_ssm_parameter" "main_redis_pass" {
  count       = (var.encryption == true) ? 1 : 0
  name        = "/${var.tenant}/${var.name}/${var.environment}/elasticache/${var.cache_name}/pass"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = random_password.auth[0].result

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-elasticache-${var.cache_name}-pass"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_ssm_parameter" "main_redis_primary" {
  count       = (var.encryption == true) ? 1 : 0
  name        = "/${var.tenant}/${var.name}/${var.environment}/elasticache/${var.cache_name}/primary"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-elasticache-${var.cache_name}-primary"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_ssm_parameter" "main_redis_reader" {
  count       = (var.encryption == true) ? 1 : 0
  name        = "/${var.tenant}/${var.name}/${var.environment}/elasticache/${var.cache_name}/reader"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-elasticache-${var.cache_name}-reader"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_ssm_parameter" "main_redis_port" {
  count       = (var.encryption == true) ? 1 : 0
  name        = "/${var.tenant}/${var.name}/${var.environment}/elasticache/${var.cache_name}/port"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = var.port

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-elasticache-${var.cache_name}-port"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}