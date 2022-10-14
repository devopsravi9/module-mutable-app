resource "aws_lb_target_group" "main-tg" {
  name             = "${local.TAG_PREFIX}-tg"
  port             = var.APP_PORT
  protocol         = "HTTP"
  vpc_id           = var.VPC_ID
  health_check {
    enabled        = true
    healthy_threshold = 2
    path           = "/health"
    unhealthy_threshold = 2
    interval       = 6
    timeout        = 5
  }
}

resource "aws_lb_target_group_attachment" "main" {
  count            = var.INSTANCE_COUNT
  target_group_arn = aws_lb_target_group.main-tg.arn
  target_id        = aws_spot_instance_request.main.*.spot_instance_id[count.index]
  port             = var.APP_PORT
}

resource "aws_lb_listener" "frontend" {
  count             = var.COMPONENT == "frontend" ? 1 : 0
  load_balancer_arn = var.PUBLIC_LB_ARN
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:us-east-1:041583668323:certificate/7421a91c-7f8f-41ee-8fc4-b190e3f8aad8"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main-tg.arn
  }
}
