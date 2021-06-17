
variable "region" {
  description = "The region of the RDS instance"
  type = string
  default = "us-east-1"
}

variable "api_name" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

# variable "lambda_function_arn" {
#   description = "The Availability Zone of the RDS instance"
#   type = string
# }

variable "lambda_function_name" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

//variable "lambda_role" {
//  description = "The Availability Zone of the RDS instance"
//  type = string
//}

variable "lambda_handler" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "lambda_runtime" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "lambda_timeout" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "lambda_layer_name" {
  description = "lambda_layer_name"
  type = string
}

variable "lambda_layer_compatible_runtimes" {
  type = list(string)
  default = [
    "python3.7"]
}

variable "s3_bucket" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "s3_key" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "s3_bucket_layer" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

variable "s3_key_layer" {
  description = "The Availability Zone of the RDS instance"
  type = string
}

