# Update SSO Lambda KMS Key

resource "aws_kms_key" "aft_kms_key" {
  description         = "AFT KMS Keys for Data Encryption"
  is_enabled          = true
  enable_key_rotation = true
  tags = {
    Name = "aft_kms_key"
  }
  policy = data.aws_iam_policy_document.key_initial.json
}


# Update SSO Lambda KMS Key ALias

resource "aws_kms_alias" "aft_kms_alias" {
  target_key_id = aws_kms_key.aft_kms_key.key_id
  name          = "alias/aft_kms_key_alias"
}


