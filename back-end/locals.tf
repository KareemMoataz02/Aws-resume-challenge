locals {
  default_tags = {
    "environment" = "dev"
    "automation"  = "terraform"
    "project"     = var.application_name
  }

  subdomain = "portofolio-${var.domain_name}"
}
