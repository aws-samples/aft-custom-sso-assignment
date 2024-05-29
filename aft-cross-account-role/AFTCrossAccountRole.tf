terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "XXXXXXX" # Your AWS Region
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
          AWS = "XXXXXXXXXXXXX" # AFT Management Account ID
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
          "organizations:CreateAccountAssignment",
          "organizations:DescribeAccountAssignmentCreationStatus"
        ]
        Effect = "Allow"
        Resource = "arn:aws:organizations::XXXXXXXXXXXXX:organization/o-xxxxxxxxxxx" # Control Tower Account ID
      }
    ]
  })
}