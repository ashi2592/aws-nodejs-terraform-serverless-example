provider "aws" {
  region = "us-east-1"  # Specify your desired region here
}

resource "aws_lambda_function" "function1" {
  filename      = "lambda1.zip"
  function_name = "function1"
  role          = "arn:aws:iam::123456789012:role/lambda-role"
  handler       = "index.handler"
  runtime       = "nodejs14.x"  # Adjust the runtime as per your requirement

  environment {
    variables = {
      ENV_VAR_1 = var.EnvironmentVariable1
      ENV_VAR_2 = var.EnvironmentVariable2
    }
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "MyAPIGateway"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "mylambda1"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"  # Adjust HTTP method as per your requirement
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = aws_lambda_function.function1.invoke_arn
}

resource "aws_lambda_permission" "apigw_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function1.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

variable "EnvironmentVariable1" {
  description = "Value for Environment Variable 1"
  default     = "value1"
}

variable "EnvironmentVariable2" {
  description = "Value for Environment Variable 2"
  default     = "value2"
}
