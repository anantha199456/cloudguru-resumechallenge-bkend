
#Static Website Hosting S3
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my.cloudresume.com"
  acl    = "public-read"
  policy = file("s3-policy.json")

  website {
    index_document = "index.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin-access-identity/${var.bucket_name}"

}

locals {
  s3_origin_id = "myS3Origin"
}

#CloudFront using the Static Webhosting s3
resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path

    }

  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.comment
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
    "PUT"]
    cached_methods = [
      "GET",
    "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  # Cache behavior with precedence 0
  ordered_cache_behavior {
    path_pattern = "/*"
    allowed_methods = [
      "GET",
      "HEAD",
    "OPTIONS"]
    cached_methods = [
      "GET",
      "HEAD",
    "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false
      headers = [
      "Origin"]

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"

    }
  }

  viewer_certificate {
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.acm_certificate_arn
  }
}

module "s3_create_bucket" {
  source = "../backend/s3"
  region = "us-east-1"
  bucket = "cloudresumeanantha"
  acl = "private"
}

module "s3_upload" {
  source = "../backend/s3_upload"
  region = "us-east-1"
  bucket = module.s3_create_bucket.s3_bucket
  acl = "public-read"
  upload_files_path = "./files_to_upload/"
  depends_on = [
    module.s3_create_bucket]
}

module "lambda_function" {
  source = "../backend/lambda"
  lambda_function_name = "site_visitor_count"
  lambda_handler = "counter.lambda_handler"
  lambda_runtime = "python3.7"
  lambda_timeout = 30
  s3_bucket = module.s3_create_bucket.s3_bucket
  s3_key = "counter.zip"
  s3_bucket_layer = module.s3_create_bucket.s3_bucket
  s3_key_layer = "python.zip"
  depends_on = [
    module.s3_upload
  ]
  lambda_layer_name = "pythonlibs"
  #api gateway configurations
  api_name = "visitor_counter_invoker"
  #lambda_function_arn = module.lambda_function.function_arn
  #lambda_function_name = module.lambda_function.lambda_function_name
}



module "dynamodb" {
  source = "../backend/dynamodb"
  table_name = "siteVisits"
}




