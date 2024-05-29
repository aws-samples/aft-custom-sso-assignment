# Update Alternate SSO Configuration
resource "aws_cloudwatch_log_group" "aft_function_log_group" {
  name              = "aft_account_provisioning_customizations_log"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.aft_kms_key.arn
  tags              = var.default_tags
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_sfn_state_machine" "aft_account_provisioning_customizations" {
  name = "aft-account-provisioning-customizations"
  tags = var.default_tags
  tracing_configuration {
    enabled = true
  }
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.aft_function_log_group.arn}:*"
    include_execution_data = true
    level                  = "ERROR"
  }
  role_arn = aws_iam_role.aft_alternate_sso_state_role.arn
  definition = templatefile("${path.module}/states/alternate-sso.asl.json", {
    data_aft_alternate_sso_extract_lambda = aws_lambda_function.aft_alternate_sso_extract_lambda.arn
  })
}