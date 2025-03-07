resource "aws_elasticache_replication_group" "main" {
  automatic_failover_enabled         = var.multi_az
  multi_az_enabled                   = var.multi_az
  num_cache_clusters                 = var.replica_count
  auto_minor_version_upgrade         = var.auto_minor_version_upgrade
  transit_encryption_enabled         = (var.encryption == true) ? true : false
  auth_token                         = (var.encryption == true) ? random_password.auth[0].result : null
  at_rest_encryption_enabled         = (var.encryption == true) ? true : false
  kms_key_id                         = (var.encryption == true) ? var.kms_key_id : null
  engine                             = "redis"
  engine_version                     = var.engine_version
  port                               = var.port
  replication_group_id               = "${var.tenant}-${var.name}-${var.cache_name}-${var.environment}"
  description                        = "Managed by Magicorn"
  node_type                          = var.instance_type
  parameter_group_name               = var.parameter_group
  maintenance_window                 = var.maintenance_window
  snapshot_window                    = var.snapshot_window
  snapshot_retention_limit           = var.snapshot_retention_limit
  final_snapshot_identifier          = "${var.tenant}-${var.name}-${var.cache_name}-final-${random_id.backup.hex}-${var.environment}"
  subnet_group_name                  = aws_elasticache_subnet_group.main.name
  security_group_ids                 = [aws_security_group.main.id]

  lifecycle {
    ignore_changes = [
      log_delivery_configuration
    ]
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.cache_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}