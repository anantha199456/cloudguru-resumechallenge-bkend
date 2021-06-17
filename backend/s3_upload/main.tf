resource "aws_s3_bucket_object" "file_upload" {
  acl = var.acl
  for_each = fileset(var.upload_files_path, "*")
  bucket = var.bucket
  key = each.value
  source = "${var.upload_files_path}${each.value}"
  etag = filemd5("${var.upload_files_path}${each.value}")
}

# resource "aws_s3_bucket_object" "file_upload_web" {
#   acl = "public-read"
#   #for_each = fileset("./website/", "*")
#   bucket = "my.cloudresume.com"
#   key = "index.html"
#   source = "index.html"
#   #etag = filemd5("${var.upload_files_path}${each.value}")
# }