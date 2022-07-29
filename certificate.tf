# Reference to the AWS Route53 Public Zone
data "aws_route53_zone" "public-zone" {
  name         = var.public_dns_name
  private_zone = false
}
# Create AWS Route53 A Record for the Load Balancer
resource "aws_route53_record" "alb-a-record" {
  depends_on = [aws_lb.vijay-alb]
  zone_id    = data.aws_route53_zone.public-zone.zone_id
  name       = "${var.dns_hostname}.${var.public_dns_name}"
  type       = "A"
  alias {
    name                   = aws_lb.vijay-alb.dns_name
    zone_id                = aws_lb.vijay-alb.zone_id
    evaluate_target_health = true
  }
}


# Create Certificate
resource "aws_acm_certificate" "alb-certificate" {
  domain_name       = "${var.dns_hostname}.${var.public_dns_name}"
  validation_method = "DNS"

  tags = {
    Name = "alb-certificate"
  }
}
# Create AWS Route 53 Certificate Validation Record
resource "aws_route53_record" "alb-certificate-validation-record" {
  for_each = {
    for dvo in aws_acm_certificate.alb-certificate.domain_validation_options : dvo.domain_name => {
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
  zone_id         = data.aws_route53_zone.public-zone.zone_id
}
# Create Certificate Validation
resource "aws_acm_certificate_validation" "certificate-validation" {
  certificate_arn         = aws_acm_certificate.alb-certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.alb-certificate-validation-record : record.fqdn]
}
