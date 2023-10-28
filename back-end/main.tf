data "aws_cloudfront_response_headers_policy" "headers_policy" {
  name = "Managed-SecurityHeadersPolicy"
}

module "cloudfront_s3" {
  source = "./modules/cloudfront-s3-cdn"

  bucket_name     = var.bucket_name
  log_bucket_name = "${var.bucket_name}-cloudfront-logs"
  ssl_cert_arn    = module.acm.acm_certificate_arn
  aliases         = [var.domain_name]


  response_headers_policy_id = data.aws_cloudfront_response_headers_policy.headers_policy.id

  depends_on = [
    module.acm
  ]

}



