resource "aws_route53_record" "route" {
  zone_id = var.PRIVATE_ZONE_ID
  name    = "${var.ENV}-${var.COMPONENT}"
  type    = "CNAME"
  ttl     = 30
  records = [var.PRIVATE_LB_DNS]
}