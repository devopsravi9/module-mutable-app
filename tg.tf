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
