resource "aws_api_gateway_rest_api" "invoke_counter" {
  name        = var.api_name
  description = "API Gateway for Counter"
}

resource "aws_api_gateway_resource" "visitorCounter_resource" {
  parent_id   = aws_api_gateway_rest_api.invoke_counter.root_resource_id
  path_part   = "visitorCounter"
  rest_api_id = aws_api_gateway_rest_api.invoke_counter.id
}

resource "aws_api_gateway_method" "visitorCounter_resource_method" {
  rest_api_id   = aws_api_gateway_rest_api.invoke_counter.id
  resource_id   = aws_api_gateway_resource.visitorCounter_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.invoke_counter.id
  resource_id             = aws_api_gateway_resource.visitorCounter_resource.id
  http_method             = aws_api_gateway_method.visitorCounter_resource_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_function_arn
}

