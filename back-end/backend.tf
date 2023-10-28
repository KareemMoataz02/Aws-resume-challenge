# Terraform backend configuration
terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "angular-app-bucket-backend"
    key            = "terraform.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-state"
  }
}

# IAM policy for S3 bucket
resource "aws_iam_policy" "s3_policy" {
  name        = "TerraformS3Policy"
  description = "Policy for Terraform S3 backend"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "s3:ListBucket",
        Effect   = "Allow",
        Resource = "arn:aws:s3:::angular-app-bucket-backend",
      },
      {
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"],
        Effect = "Allow",
        "Resource" : "*",
      },
    ]
  })
}

# IAM policy for DynamoDB table
resource "aws_iam_policy" "dynamodb_policy" {
  name        = "TerraformDynamoDBPolicy"
  description = "Policy for Terraform DynamoDB locking"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
        ],
        Effect = "Allow",
        "Resource" : "*",
      },
    ]
  })
}

# Create an IAM role for S3 backend
resource "aws_iam_role" "s3_backend_role" {
  name = "S3BackendRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        }
      }
    ]
  })
}

# Create an IAM role for DynamoDB backend
resource "aws_iam_role" "dynamodb_backend_role" {
  name = "DynamoDBBackendRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the S3 policy to the S3 backend role
resource "aws_iam_policy_attachment" "s3_attachment" {
  name       = "TerraformS3PolicyAttachment"
  policy_arn = aws_iam_policy.s3_policy.arn
  roles      = [aws_iam_role.s3_backend_role.name]
}

# Attach the DynamoDB policy to the DynamoDB backend role
resource "aws_iam_policy_attachment" "dynamodb_attachment" {
  name       = "TerraformDynamoDBPolicyAttachment"
  policy_arn = aws_iam_policy.dynamodb_policy.arn
  roles      = [aws_iam_role.dynamodb_backend_role.name]
}
