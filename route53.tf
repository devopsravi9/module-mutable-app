resource "aws_route53_record" "www" {
  zone_id = var.PRIVATE_ZONE_ID
  name    = "${var.ENV}-${var.COMPONENT}"
  type    = "CNAME"
  ttl     = 300
  records = [aws_lb_target_group.main-tg.arn]
}