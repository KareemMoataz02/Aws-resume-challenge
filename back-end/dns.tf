module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "${var.domain_name}" = {
      comment = "(development)"
      tags = {
        env = "development"
      }
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

module "acm" {
  source = "terraform-aws-modules/acm/aws"

  providers = {
    aws = aws.us-east-1
  }

  domain_name = var.domain_name
  zone_id     = module.zones.route53_zone_zone_id["${var.domain_name}"]

  validation_method = "DNS"

  wait_for_validation    = true
  create_route53_records = false

  tags = {
    Name = "${var.domain_name}-acm"
  }
  depends_on = [module.zones]
}

resource "aws_route53_record" "myapp" {
  zone_id = module.zones.route53_zone_zone_id["${var.domain_name}"]
  name    = var.domain_name
  type    = "A"
  alias {
    name                   = module.cloudfront_s3.cloudfront_distribution_domain_name
    zone_id                = module.cloudfront_s3.cloudfront_distribution_hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [module.zones, module.cloudfront_s3]
}
