resource "aws_iam_role" "get_lambda_role" {
  name = "get_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
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
resource "aws_iam_role" "post_lambda_role" {
  name = "post_lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
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

resource "aws_iam_role" "dynamodb_policy_get_options" {
  name = "DynamoDBPolicygetOptions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
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

resource "aws_iam_role" "dynamodb_policy_post_options" {
  name = "DynamoDBPolicypostOptions"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
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



# Create DynamoDB Policy
resource "aws_iam_policy" "dynamodb_policy_get" {
  name        = "DynamoDBPolicyget"
  description = "Allows DynamoDB access for Lambda functions"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "apigateway:GET",
            "apigateway:OPTIONS",
            "cloudtrail:CreateTrail",
            "cloudtrail:StartLogging",
            "ec2:Describe*",
            "lambda:ListFunctions",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:PutLogEvents",
            "sns:Get*",
            "sns:List*",
            "sns:Publish",
            "sns:Subscribe",
            "xray:Put*",

            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWrite*",
            "dynamodb:CreateTable",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem",

            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : [
            "*"
          ]

          "Effect" : "Allow"
        }
      ]
    }
  )

}
resource "aws_iam_policy" "dynamodb_policy_post" {
  name        = "DynamoDBPolicypost"
  description = "Allows DynamoDB access for Lambda functions"

  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : [
            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : "*",
          "Effect" : "Allow"
        },
        {
          "Action" : [
            "apigateway:GET",
            "apigateway:OPTIONS",
            "cloudtrail:CreateTrail",
            "cloudtrail:StartLogging",
            "ec2:Describe*",
            "lambda:ListFunctions",
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:DescribeLogGroups",
            "logs:PutLogEvents",
            "sns:Get*",
            "sns:List*",
            "sns:Publish",
            "sns:Subscribe",
            "xray:Put*",

            "dynamodb:BatchGet*",
            "dynamodb:DescribeStream",
            "dynamodb:DescribeTable",
            "dynamodb:Get*",
            "dynamodb:Query",
            "dynamodb:Scan",
            "dynamodb:BatchWrite*",
            "dynamodb:CreateTable",
            "dynamodb:Delete*",
            "dynamodb:Update*",
            "dynamodb:PutItem",

            "dynamodb:List*",
            "dynamodb:DescribeReservedCapacity*",
            "dynamodb:DescribeLimits",
            "dynamodb:DescribeTimeToLive"
          ],
          "Resource" : [
            "*"
          ]

          "Effect" : "Allow"
        }
      ]
    }
  )

}

# Attach DynamoDB Policy to IAM Roles
resource "aws_iam_policy_attachment" "get_lambda_dynamodb" {
  name       = "dynamodb-attachment-get"
  policy_arn = aws_iam_policy.dynamodb_policy_get.arn
  roles      = [aws_iam_role.get_lambda_role.name]
}

resource "aws_iam_policy_attachment" "post_lambda_dynamodb" {
  name       = "dynamodb-attachment-post"
  policy_arn = aws_iam_policy.dynamodb_policy_post.arn
  roles      = [aws_iam_role.post_lambda_role.name]
}

resource "aws_iam_policy_attachment" "get_lambda_dynamodb_options" {
  name       = "dynamodb-attachment-get-options"
  policy_arn = aws_iam_policy.dynamodb_policy_get.arn
  roles      = [aws_iam_role.get_lambda_role.name]
}

resource "aws_iam_policy_attachment" "post_lambda_dynamodb_options" {
  name       = "dynamodb-attachment-post-options"
  policy_arn = aws_iam_policy.dynamodb_policy_post.arn
  roles      = [aws_iam_role.post_lambda_role.name]
}

# GetLambda
resource "aws_api_gateway_integration" "getintegration" {
  rest_api_id             = aws_api_gateway_rest_api.getapi.id
  resource_id             = aws_api_gateway_resource.getapiresource.id
  http_method             = aws_api_gateway_method.getapimethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.getlambda.invoke_arn
}

resource "aws_api_gateway_integration" "getoptionsintegration" {
  rest_api_id             = aws_api_gateway_rest_api.getapi.id
  resource_id             = aws_api_gateway_resource.getapiresource.id
  http_method             = aws_api_gateway_method.getoptionsmethod.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}

resource "aws_lambda_permission" "getapigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.getlambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.getapi.id}/*/${aws_api_gateway_method.getapimethod.http_method}${aws_api_gateway_resource.getapiresource.path}"

}

resource "aws_lambda_function" "getlambda" {
  filename      = "get.zip"
  function_name = "getlambda"
  role          = aws_iam_role.get_lambda_role.arn
  handler       = "get.lambda_handler"
  runtime       = "python3.7"

  source_code_hash = filebase64sha256("./get.zip")
  depends_on       = [aws_iam_policy_attachment.get_lambda_dynamodb]
}

# PostLambda

resource "aws_api_gateway_integration" "postintegration" {
  rest_api_id             = aws_api_gateway_rest_api.postapi.id
  resource_id             = aws_api_gateway_resource.postapiresource.id
  http_method             = aws_api_gateway_method.postapimethod.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.postlambda.invoke_arn
}

resource "aws_api_gateway_integration" "postoptionsintegration" {
  rest_api_id             = aws_api_gateway_rest_api.postapi.id
  resource_id             = aws_api_gateway_resource.postapiresource.id
  http_method             = aws_api_gateway_method.postoptionsmethod.http_method
  integration_http_method = "OPTIONS"
  type                    = "MOCK"
  request_templates = {
    "application/json" = jsonencode(
      {
        statusCode = 200
      }
    )
  }
}


resource "aws_lambda_permission" "postapigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.postlambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.accountId}:${aws_api_gateway_rest_api.postapi.id}/*/${aws_api_gateway_method.postapimethod.http_method}${aws_api_gateway_resource.postapiresource.path}"

}

resource "aws_lambda_function" "postlambda" {
  filename         = "post.zip"
  function_name    = "postlambda"
  role             = aws_iam_role.post_lambda_role.arn
  handler          = "post.lambda_handler"
  runtime          = "python3.7"
  source_code_hash = filebase64sha256("./post.zip")
  depends_on       = [aws_iam_policy_attachment.post_lambda_dynamodb]
}
