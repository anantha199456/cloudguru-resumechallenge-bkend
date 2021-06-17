output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.site_counter.arn
}

output "base_url" {
  value = aws_api_gateway_deployment.apigdeploy.invoke_url
}