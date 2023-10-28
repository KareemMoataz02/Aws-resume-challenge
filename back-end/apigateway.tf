resource "aws_api_gateway_rest_api" "getapi" {
  name        = "getapi"
  description = "get visitors count"
}

resource "aws_api_gateway_resource" "getapiresource" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id
  parent_id   = aws_api_gateway_rest_api.getapi.root_resource_id
  path_part   = "getapiresource"
  depends_on  = [aws_api_gateway_rest_api.getapi]


}

resource "aws_api_gateway_method" "getapimethod" {
  rest_api_id   = aws_api_gateway_rest_api.getapi.id
  resource_id   = aws_api_gateway_resource.getapiresource.id
  http_method   = "GET"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_rest_api.getapi]
}

resource "aws_api_gateway_method_response" "getapimethod_cors_response" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id
  resource_id = aws_api_gateway_resource.getapiresource.id
  http_method = aws_api_gateway_method.getapimethod.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.getapimethod]
}

resource "aws_api_gateway_integration_response" "getapimethod_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id
  resource_id = aws_api_gateway_resource.getapiresource.id
  http_method = aws_api_gateway_method.getapimethod.http_method
  status_code = aws_api_gateway_method_response.getapimethod_cors_response.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
  "method.response.header.Access-Control-Allow-Methods" = "'*'" }

  depends_on = [aws_api_gateway_method_response.getapimethod_cors_response, aws_api_gateway_integration.getintegration]
}

resource "aws_api_gateway_deployment" "getdeployment" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.getapiresource.id,
      aws_api_gateway_method.getapimethod.id,
      aws_api_gateway_integration.getintegration.id,
      aws_api_gateway_method.getoptionsmethod.id,
      aws_api_gateway_integration.getoptionsintegration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "getstage" {
  deployment_id = aws_api_gateway_deployment.getdeployment.id
  rest_api_id   = aws_api_gateway_rest_api.getapi.id
  stage_name    = "getprod"
}

resource "aws_api_gateway_rest_api" "postapi" {
  name        = "postapi"
  description = "increment visitors count"
}

resource "aws_api_gateway_resource" "postapiresource" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id
  parent_id   = aws_api_gateway_rest_api.postapi.root_resource_id
  path_part   = "postapiresource"
  depends_on  = [aws_api_gateway_rest_api.postapi]

}

resource "aws_api_gateway_method" "postapimethod" {
  rest_api_id   = aws_api_gateway_rest_api.postapi.id
  resource_id   = aws_api_gateway_resource.postapiresource.id
  http_method   = "POST"
  authorization = "NONE"

  depends_on = [aws_api_gateway_rest_api.postapi]
}

resource "aws_api_gateway_method_response" "postapimethod_cors_response" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id
  resource_id = aws_api_gateway_resource.postapiresource.id
  http_method = aws_api_gateway_method.postapimethod.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.postapimethod]
}

resource "aws_api_gateway_integration_response" "postapimethod_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id
  resource_id = aws_api_gateway_resource.postapiresource.id
  http_method = aws_api_gateway_method.postapimethod.http_method
  status_code = aws_api_gateway_method_response.postapimethod_cors_response.status_code
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
  "method.response.header.Access-Control-Allow-Methods" = "'*'" }
  depends_on = [aws_api_gateway_method_response.postapimethod_cors_response, aws_api_gateway_integration.postintegration]
}

resource "aws_api_gateway_deployment" "postdeployment" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.postapiresource.id,
      aws_api_gateway_method.postapimethod.id,
      aws_api_gateway_integration.postintegration.id,
      aws_api_gateway_method.postoptionsmethod.id,
      aws_api_gateway_integration.postoptionsintegration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "poststage" {
  deployment_id = aws_api_gateway_deployment.postdeployment.id
  rest_api_id   = aws_api_gateway_rest_api.postapi.id
  stage_name    = "postprod"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name = "lambda-execution-policy"

  # Define the policy with the necessary permissions for your Lambda function.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "lambda:InvokeFunction",
        Effect   = "Allow",
        Resource = "${aws_lambda_function.getlambda.arn} , ${aws_lambda_function.postlambda.arn}"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_attachment" {
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  role       = aws_iam_role.lambda_execution_role.name
}


# Add options method for CORS for both GET and POST
resource "aws_api_gateway_method" "getoptionsmethod" {
  rest_api_id   = aws_api_gateway_rest_api.getapi.id
  resource_id   = aws_api_gateway_resource.getapiresource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_method.getapimethod]
}

resource "aws_api_gateway_method_response" "getoptionsmethod_cors_response" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id
  resource_id = aws_api_gateway_resource.getapiresource.id
  http_method = aws_api_gateway_method.getoptionsmethod.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.getoptionsmethod]
}

resource "aws_api_gateway_integration_response" "getoptionsmethod_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.getapi.id
  resource_id = aws_api_gateway_resource.getapiresource.id
  http_method = aws_api_gateway_method.getoptionsmethod.http_method
  status_code = 200
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.postoptionsmethod_cors_response, aws_api_gateway_integration.postoptionsintegration]
}


resource "aws_api_gateway_method" "postoptionsmethod" {
  rest_api_id   = aws_api_gateway_rest_api.postapi.id
  resource_id   = aws_api_gateway_resource.postapiresource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
  depends_on    = [aws_api_gateway_method.postapimethod]
}

resource "aws_api_gateway_method_response" "postoptionsmethod_cors_response" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id
  resource_id = aws_api_gateway_resource.postapiresource.id
  http_method = aws_api_gateway_method.postoptionsmethod.http_method
  status_code = 200
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
  }
  depends_on = [aws_api_gateway_method.postoptionsmethod]
}

resource "aws_api_gateway_integration_response" "postoptionsmethod_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.postapi.id
  resource_id = aws_api_gateway_resource.postapiresource.id
  http_method = aws_api_gateway_method.postoptionsmethod.http_method
  status_code = 200
  response_templates = {
    "application/json" = ""
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,X-Amz-User-Agent'"
    "method.response.header.Access-Control-Allow-Methods" = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.postoptionsmethod_cors_response, aws_api_gateway_integration.postoptionsintegration]
}
