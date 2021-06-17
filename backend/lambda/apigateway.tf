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
  http_method             = aws_api_gateway_method.visitorCounter_resource_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.site_counter.invoke_arn
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.site_counter.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.invoke_counter.execution_arn}/*/GET/visitorCounter"
}


resource "aws_api_gateway_deployment" "apigdeploy" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]

  rest_api_id = aws_api_gateway_rest_api.invoke_counter.id
  stage_name  = "Deploy"
}
