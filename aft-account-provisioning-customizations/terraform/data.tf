# Update Alternate SSO
data "aws_region" "aft_management_region" {}

data "aws_caller_identity" "aft_management_id" {}

data "aws_kms_key" "key_alias" {
  key_id = "alias/aws/lambda"
}

data "aws_iam_policy" "AmazonEC2FullAccess" {
  name = "AmazonEC2FullAccess"
}

data "aws_iam_policy" "AmazonSQSFullAccess" {
  name = "AmazonSQSFullAccess"
}

data "aws_iam_policy" "CloudWatchFullAccess" {
  name = "CloudWatchFullAccess"
}

data "aws_ssm_parameter" "aft_request_metadata_table_name" {
  name = "/aft/resources/ddb/aft-request-metadata-table-name"
}

data "aws_dynamodb_table" "aft_request_metadata_table" {
  name = data.aws_ssm_parameter.aft_request_metadata_table_name.value
}

data "archive_file" "aft_alternate_sso_extract" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/aft_add_alternate_sso"
  output_path = "${path.module}/lambda/aft_add_alternate_sso.zip"
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}


data "aws_iam_policy_document" "lambda_assume_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = ["arn:aws:iam::${var.aft_ct_account_id}:role/${var.aft_cross_account_role_name}"]
  }
}

data "aws_iam_policy_document" "assume_role_policy_states" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["states.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "key_initial" {
  statement {
    sid = "Enable IAM User Permissions"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.aft_management_id.account_id}:root"]
    }
    actions   = ["kms:Encrypt", "kms:Decrypt"]
    resources = ["arn:aws:kms:${data.aws_region.aft_management_region.name}:${data.aws_caller_identity.aft_management_id.account_id}:*"]
  }

  statement {
    sid = "allow-cloudwatch-logs-to-use"
    principals {
      type        = "Service"
      identifiers = ["logs.amazonaws.com"]
    }
    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["arn:aws:kms:${data.aws_region.aft_management_region.name}:${data.aws_caller_identity.aft_management_id.account_id}:*"]
    condition {
      test     = "ArnEquals"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values   = ["arn:aws:logs:${data.aws_region.aft_management_region.name}:${data.aws_caller_identity.aft_management_id.account_id}:log-group:*"]
    }
  }
}