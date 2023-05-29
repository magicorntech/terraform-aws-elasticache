resource "aws_kms_key" "main" {
  count                   = (var.encryption == true) ? 1 : 0
  description             = "${var.tenant}-${var.name}-elasticache-kms-${var.environment}"
  key_usage               = "ENCRYPT_DECRYPT" 
  deletion_window_in_days = 7
  enable_key_rotation     = true
  multi_region            = false
  is_enabled              = true

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "auto-elasticache-1",
    "Statement": [
        {
            "Sid": "Allow access through ElastiCache for all principals in the account that are authorized to use ElastiCache",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:CreateGrant",
                "kms:ListGrants",
                "kms:DescribeKey"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "kms:ViaService": "elasticache.${data.aws_region.current.name}.amazonaws.com",
                    "kms:CallerAccount": "${data.aws_caller_identity.current.account_id}"
                }
            }
        },
        {
            "Sid": "Allow direct access to key metadata to the account",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                  "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
                  "${data.aws_caller_identity.current.arn}"
                ]
            },
            "Action": [
                "kms:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF

  tags = {
    Name        = "${var.tenant}-${var.name}-elasticache-kms-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_kms_alias" "main" {
  count         = (var.encryption == true) ? 1 : 0
  name          = "alias/${var.tenant}/${var.name}/elasticache/${var.environment}"
  target_key_id = aws_kms_key.main[0].key_id
}