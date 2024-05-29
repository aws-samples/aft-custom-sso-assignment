# Update Alternate SSO

output "aft_alternate_sso_state_machine_arn" {
  description = "State machine ARN"
  value       = aws_sfn_state_machine.aft_account_provisioning_customizations.arn
}

output "aft_alternate_sso_extract_lambda_arn" {
  description = "aft-alternate-sso-extract Lambda ARN"
  value       = aws_lambda_function.aft_alternate_sso_extract_lambda.arn
}