terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.8.0"
    }
  }
}

provider "aws" {
  region = "" # Your AWS Region
}

resource "aws_iam_role" "AFTCrossAccountRole" {
  name = "AFTCrossAccountRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "xxxxxxxxxxxx" # AFT Management Account ID
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "account_assignment_policy" {
  name = "account-assignment-policy"
  role = aws_iam_role.AFTCrossAccountRole.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sso:CreateAccountAssignment",
          "sso:DescribeAccountAssignmentCreationStatus"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:organizations::xxxxxxxxxxxx:organization/o-xxxxxxxxxxx" # Control Tower Account ID
      }
    ]
  })
}