# Retrieve AWS Account Information
data "aws_caller_identity" "current" {}

data "aws_availability_zones" "available" {}

data "aws_route53_zone" "public_domain" {
  name         = local.public_domain
  private_zone = false
}
