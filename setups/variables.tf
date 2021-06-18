variable "bucket_name" {
  type        = string
  description = "The name of the bucket without the www. prefix. Normally domain_name."
  default     = "resume-archive_backend"
}

variable "comment" {
  type        = string
  description = "CloudFront Distribution for resume hosting."
  default     = "CloudFront Distribution for resume hosting."
}

variable "acm_certificate_arn" {
  type        = string
  description = "acm arn"
  default     = "arn:aws:acm:us-east-1:272833614684:certificate/717c5180-b17a-4426-9147-c86fb5983ed0"
}