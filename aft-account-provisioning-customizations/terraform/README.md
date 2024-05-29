<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.aft_alternate_sso_extract_lambda_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.aft_function_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.aft_alternate_sso_extract_lambda_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aft_alternate_sso_state_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.aft_alternate_sso_state_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.aft_alternate_sso_extract_lambda_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.assume_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.state-machine_role_policy_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.aft_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.aft_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_lambda_code_signing_config.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_code_signing_config) | resource |
| [aws_lambda_function.aft_alternate_sso_extract_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_sfn_state_machine.aft_account_provisioning_customizations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sfn_state_machine) | resource |
| [aws_signer_signing_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/signer_signing_profile) | resource |
| [aws_sqs_queue.aftlambdadlq](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sqs_queue) | resource |
| [archive_file.aft_alternate_sso_extract](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [aws_caller_identity.aft_management_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_dynamodb_table.aft_request_metadata_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/dynamodb_table) | data source |
| [aws_iam_policy.AmazonEC2FullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.AmazonSQSFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.CloudWatchFullAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.assume_role_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.assume_role_policy_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.key_initial](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_assume_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.key_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/kms_key) | data source |
| [aws_region.aft_management_region](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_ssm_parameter.aft_request_metadata_table_name](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aft_cross_account_role_name"></a> [aft\_cross\_account\_role\_name](#input\_aft\_cross\_account\_role\_name) | CT Account role name | `string` | `"AFTCrossAccountRole"` | no |
| <a name="input_aft_ct_account_id"></a> [aft\_ct\_account\_id](#input\_aft\_ct\_account\_id) | Private Subnet Security Group | `string` | `"XXXXXXXXXXXXXX"` | no |
| <a name="input_cloudwatch_log_group_retention"></a> [cloudwatch\_log\_group\_retention](#input\_cloudwatch\_log\_group\_retention) | Lambda CloudWatch log group retention period | `string` | `"365"` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags for the module | `map(string)` | <pre>{<br>  "CostCenter": "ACME",<br>  "Environment": "AFT",<br>  "Owner": "ACME Corp",<br>  "Project": "ACME Project"<br>}</pre> | no |
| <a name="input_private1_subnet_id"></a> [private1\_subnet\_id](#input\_private1\_subnet\_id) | Private Subnet 1 | `string` | `"subnet-XXXXXXXXXXXXXX"` | no |
| <a name="input_private2_subnet_id"></a> [private2\_subnet\_id](#input\_private2\_subnet\_id) | Private Subnet 2 | `string` | `"subnet-XXXXXXXXXXXXXX"` | no |
| <a name="input_private_sg_id"></a> [private\_sg\_id](#input\_private\_sg\_id) | Private Subnet Security Group | `string` | `"sg-XXXXXXXXXXXXXX"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aft_alternate_sso_extract_lambda_arn"></a> [aft\_alternate\_sso\_extract\_lambda\_arn](#output\_aft\_alternate\_sso\_extract\_lambda\_arn) | aft-alternate-sso-extract Lambda ARN |
| <a name="output_aft_alternate_sso_state_machine_arn"></a> [aft\_alternate\_sso\_state\_machine\_arn](#output\_aft\_alternate\_sso\_state\_machine\_arn) | State machine ARN |
<!-- END_TF_DOCS -->