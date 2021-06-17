resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = var.lambda_layer_name
  s3_bucket = var.s3_bucket_layer
  s3_key = var.s3_key_layer
}

# Zip the function to be run at function app
# data "archive_file" "init" {
#   type        = "zip"
#   source_file = "${path.module}/../../counter.py"
#   output_path = "${path.module}../setups/files_to_upload/counter.zip"
# }

resource "aws_lambda_function" "site_counter" {
  function_name = var.lambda_function_name
  role = aws_iam_role.lambda_sns_role01.arn
  handler = var.lambda_handler
  runtime = var.lambda_runtime
  timeout = var.lambda_timeout
  s3_bucket = var.s3_bucket
  s3_key = var.s3_key
  depends_on = [
    aws_iam_role.lambda_sns_role01
  ]
  layers = [
    aws_lambda_layer_version.lambda_layer.arn
  ]
}
