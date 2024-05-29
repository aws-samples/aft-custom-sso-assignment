# Update Alternate SSO Lambda Role

resource "aws_iam_role" "aft_alternate_sso_extract_lambda_role" {
  name               = "aft-alternate-sso-extract-lambda-role"
  tags               = var.default_tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
}

# Update Alternate SSO Lambda Role Policy

resource "aws_iam_role_policy_attachment" "assume_policy_attach" {
  role       = aws_iam_role.aft_alternate_sso_extract_lambda_role.name
  policy_arn = data.aws_iam_policy_document.lambda_assume_policy.json
}


resource "aws_iam_role_policy_attachment" "aft_alternate_sso_extract_lambda_role_policy_attachment" {
  count      = length(local.lambda_managed_policies)
  role       = aws_iam_role.aft_alternate_sso_extract_lambda_role.name
  policy_arn = local.lambda_managed_policies[count.index]
}


# Update Alternate SSO Step Function Role

resource "aws_iam_role" "aft_alternate_sso_state_role" {
  name               = "aft-alternate-sso-state-role"
  tags               = var.default_tags
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_states.json
}


resource "aws_iam_role_policy" "aft_alternate_sso_state_role_policy" {
  name = "aft-alternate-sso-state-role-policy"
  role = aws_iam_role.aft_alternate_sso_state_role.id

  policy = templatefile("${path.module}/iam/role-policies/state-aft-alternate-sso-role-policy.tpl", {
    data_aws_region     = data.aws_region.aft_management_region.name
    data_aws_account_id = data.aws_caller_identity.aft_management_id.account_id
  })
}



resource "aws_iam_role_policy_attachment" "state-machine_role_policy_attach" {
  role       = aws_iam_role.aft_alternate_sso_state_role.name
  policy_arn = data.aws_iam_policy.CloudWatchFullAccess.arn
}