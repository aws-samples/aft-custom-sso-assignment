# Update SSO Lambda function DLQ

resource "aws_sqs_queue" "aftlambdadlq" {
  name                       = "sampledlq"
  delay_seconds              = 300
  max_message_size           = 2048
  message_retention_seconds  = 1209600
  visibility_timeout_seconds = 310
  receive_wait_time_seconds  = 20
  sqs_managed_sse_enabled    = true
  tags                       = var.default_tags
}

# Update SSO Lambda function Code Signing

resource "aws_lambda_code_signing_config" "this" {
  description = "Code signing config for AFT Lambda"

  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.this.arn,
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }
}

# Update SSO Lambda function Code Signing Profile

resource "aws_signer_signing_profile" "this" {
  name_prefix = "AwsLambdaCodeSigningAction"
  platform_id = "AWSLambda-SHA384-ECDSA"

  signature_validity_period {
    value = 5
    type  = "YEARS"
  }

  tags = var.default_tags
}


# Setup Lambda in an existing VPC (Optional)

resource "aws_lambda_function" "aft_alternate_sso_extract_lambda" {
  filename                = data.archive_file.aft_alternate_sso_extract.output_path
  function_name           = "aft-alternate-sso-extract"
  description             = "AFT account provisioning - Alternate SSO - Extract"
  role                    = aws_iam_role.aft_alternate_sso_extract_lambda_role.arn
  handler                 = "aft-add-alternate-sso.lambda_handler"
  code_signing_config_arn = aws_lambda_code_signing_config.this.arn
  source_code_hash        = data.archive_file.aft_alternate_sso_extract.output_base64sha256
  runtime                 = "python3.9"
  timeout                 = 30
  vpc_config {
    subnet_ids         = [var.private1_subnet_id, var.private2_subnet_id]
    security_group_ids = [var.private_sg_id]
  }
  kms_key_arn = aws_kms_key.aft_kms_key.arn
  tags        = var.default_tags
  dead_letter_config {
    target_arn = aws_sqs_queue.aftlambdadlq.arn
  }
  environment {
    variables = {
      REGION              = data.aws_region.aft_management_region.id
      CROSS_ACC_ROLE_NAME = var.aft_cross_account_role_name
      AFT_CT_ACCOUNT      = var.aft_ct_account_id
    }
  }
  tracing_config {
    mode = "Active"
  }
}

# Update SSO Lambda function CloudWatch Integration

resource "aws_cloudwatch_log_group" "aft_alternate_sso_extract_lambda_log" {
  name              = "/aws/lambda/aft_alternate_sso_extract_lambda_log"
  retention_in_days = var.cloudwatch_log_group_retention
  tags              = var.default_tags
  kms_key_id        = aws_kms_key.aft_kms_key.arn
}
