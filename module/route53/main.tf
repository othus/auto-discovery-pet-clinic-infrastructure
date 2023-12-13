#Import Route53 Hosted Zone form Aws account
data "aws_route53_zone" "zone" {
  name = var.domain_name
}

# Creating stage record form Route53 zone
resource "aws_route53_record" "stage" {
  zone_id = data.aws_route53_zone.zone.id
  name = var.domain_name2
  type = "A"
  alias {
    name = var.stage_dns_name
    zone_id = var.stage_zone_id
    evaluate_target_health = false
  }
}

# Creating Production record form Route53 zone
resource "aws_route53_record" "prod" {
  zone_id = data.aws_route53_zone.zone.id
  name = var.domain_name3
  type = "A"
  alias {
    name = var.stage_dns_name2
    zone_id = var.stage_zone_id2
    evaluate_target_health = false
  }
}

# Creating Certificate for Domain name
resource "aws_acm_certificate" "raro-cert" {
  domain_name = var.domain_name
  subject_alternative_names = [ var.domain_name4 ]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

# creating record set in Route53 for Domain  Validation
resource "aws_route53_record" "raro_validation_record" {
  for_each = {
    for dvo in aws_aaws_acm_certificate.raro-cert.domain_validation_options :dvo.domain_name => {
        name = dvo.resource_record_name
        record = dvo.resource_record_value
        type = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name = each.value.name
  records = [ each.value.record ]
  type = each.value.type
  ttl = 60
  zone_id = data.aws_route53_zone.zone.zone_id
}

# Creating instruction to validate ACM Certificate
resource "aws_acm_certificate_validation" "raro-cert-validation" {
  certificate_arn = aws_acm_certificate.raro-cert.arn
  validation_record_fqdns = [ for record in aws_roaws_route53_record.raro_validation_record : record.fqdn ]
}#Import Route53 Hosted Zone form Aws account
data "aws_route53_zone" "zone" {
  name = var.domain_name
}

# # Creating stage record form Route53 zone
# resource "aws_route53_record" "stage" {
#   zone_id = data.aws_route53_zone.zone.id
#   name = var.domain_name2
#   type = "A"
#   alias {
#     name = var.stage_dns_name
#     zone_id = var.stage_zone_id
#     evaluate_target_health = false
#   }
# }

# # Creating Production record form Route53 zone
# resource "aws_route53_record" "prod" {
#   zone_id = data.aws_route53_zone.zone.id
#   name = var.domain_name3
#   type = "A"
#   alias {
#     name = var.stage_dns_name2
#     zone_id = var.stage_zone_id2
#     evaluate_target_health = false
#   }
# }

# # Creating Certificate for Domain name
# resource "aws_acm_certificate" "raro-cert" {
#   domain_name = var.domain_name
#   subject_alternative_names = [ var.domain_name4 ]
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # creating record set in Route53 for Domain  Validation
# resource "aws_route53_record" "raro_validation_record" {
#   for_each = {
#     for dvo in aws_aaws_acm_certificate.raro-cert.domain_validation_options :dvo.domain_name => {
#         name = dvo.resource_record_name
#         record = dvo.resource_record_value
#         type = dvo.resource_record_type
#     }
#   }
#   allow_overwrite = true
#   name = each.value.name
#   records = [ each.value.record ]
#   type = each.value.type
#   ttl = 60
#   zone_id = data.aws_route53_zone.zone.zone_id
# }

# # Creating instruction to validate ACM Certificate
# resource "aws_acm_certificate_validation" "raro-cert-validation" {
#   certificate_arn = aws_acm_certificate.raro-cert.arn
#   validation_record_fqdns = [ for record in aws_roaws_route53_record.raro_validation_record : record.fqdn ]
# }#Import Route53 Hosted Zone form Aws account
# data "aws_route53_zone" "zone" {
#   name = var.domain_name
# }

# # Creating stage record form Route53 zone
# resource "aws_route53_record" "stage" {
#   zone_id = data.aws_route53_zone.zone.id
#   name = var.domain_name2
#   type = "A"
#   alias {
#     name = var.stage_dns_name
#     zone_id = var.stage_zone_id
#     evaluate_target_health = false
#   }
# }

# # Creating Production record form Route53 zone
# resource "aws_route53_record" "prod" {
#   zone_id = data.aws_route53_zone.zone.id
#   name = var.domain_name3
#   type = "A"
#   alias {
#     name = var.stage_dns_name2
#     zone_id = var.stage_zone_id2
#     evaluate_target_health = false
#   }
# }

# # Creating Certificate for Domain name
# resource "aws_acm_certificate" "raro-cert" {
#   domain_name = var.domain_name
#   subject_alternative_names = [ var.domain_name4 ]
#   validation_method = "DNS"
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# # creating record set in Route53 for Domain  Validation
# resource "aws_route53_record" "raro_validation_record" {
#   for_each = {
#     for dvo in aws_aaws_acm_certificate.raro-cert.domain_validation_options :dvo.domain_name => {
#         name = dvo.resource_record_name
#         record = dvo.resource_record_value
#         type = dvo.resource_record_type
#     }
#   }
#   allow_overwrite = true
#   name = each.value.name
#   records = [ each.value.record ]
#   type = each.value.type
#   ttl = 60
#   zone_id = data.aws_route53_zone.zone.zone_id
# }

# # Creating instruction to validate ACM Certificate
# resource "aws_acm_certificate_validation" "raro-cert-validation" {
#   certificate_arn = aws_acm_certificate.raro-cert.arn
#   validation_record_fqdns = [ for record in aws_roaws_route53_record.raro_validation_record : record.fqdn ]
# }