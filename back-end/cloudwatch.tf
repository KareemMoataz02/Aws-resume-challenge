resource "aws_iam_role" "cloudwatch_logs_role" {
  name = "cloudwatch-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name = "cloudwatch-logs-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutRetentionPolicy",
          "logs:GetLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "cloudwatch_logs_policy_attachment" {
  name       = "cloudwatch-logs-policy-attachment"
  roles      = [aws_iam_role.cloudwatch_logs_role.name]
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}
