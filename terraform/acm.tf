### Weave Gitops
# Create SSL Certificate using AWS ACM for Weave Gitops
resource "aws_acm_certificate" "weave_gitops" {
  domain_name       = local.weave_gitops_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Validate SSL Certificate using DNS for Weave Gitops
resource "aws_route53_record" "weave_gitops_validation" {
  for_each = {
    for dvo in aws_acm_certificate.weave_gitops.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.route53_zone_id
}

# Retrieve SSL Certificate ARN from AWS ACM for Weave Gitops
resource "aws_acm_certificate_validation" "weave_gitops" {
  certificate_arn         = aws_acm_certificate.weave_gitops.arn
  validation_record_fqdns = [for record in aws_route53_record.weave_gitops_validation : record.fqdn]
}

### Podinfo
# Create SSL Certificate using AWS ACM for Podinfo
resource "aws_acm_certificate" "podinfo" {
  domain_name       = local.podinfo_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Validate SSL Certificate using DNS for Podinfo
resource "aws_route53_record" "podinfo_validation" {
  for_each = {
    for dvo in aws_acm_certificate.podinfo.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.route53_zone_id
}

# Retrieve SSL Certificate ARN from AWS ACM for Podinfo
resource "aws_acm_certificate_validation" "podinfo" {
  certificate_arn         = aws_acm_certificate.podinfo.arn
  validation_record_fqdns = [for record in aws_route53_record.podinfo_validation : record.fqdn]
}

### React App
# Create SSL Certificate using AWS ACM for React App
resource "aws_acm_certificate" "react_app" {
  domain_name       = local.react_app_domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Validate SSL Certificate using DNS for React App
resource "aws_route53_record" "react_app_validation" {
  for_each = {
    for dvo in aws_acm_certificate.react_app.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.route53_zone_id
}

# Retrieve SSL Certificate ARN from AWS ACM for React App
resource "aws_acm_certificate_validation" "react_app" {
  certificate_arn         = aws_acm_certificate.react_app.arn
  validation_record_fqdns = [for record in aws_route53_record.react_app_validation : record.fqdn]
}
