# Update Alternate SSO
locals {
  lambda_managed_policies = [data.aws_iam_policy.AmazonEC2FullAccess.arn, data.aws_iam_policy.AmazonSQSFullAccess.arn, data.aws_iam_policy.CloudWatchFullAccess.arn]
}