# --- loadbalancing/main.tf ---


resource "aws_lb" "mtc_lb" {
  name = "mtc-loadbalancer"
  #   load_balancer_type = "application"
  security_groups = var.public_sg
  subnets         = var.public_subnets
  idle_timeout    = 400
  tags = {
    Environment = "mtc_loadbalancer"
  }
}

resource "aws_lb_target_group" "mtc_tg" {
  name = "mtc-tg-${substr(uuid(), 0, 3)}"
  lifecycle {
    ignore_changes        = [name]
    create_before_destroy = true
  }
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = var.lb_healthy_th
    unhealthy_threshold = var.lb_unhealthy_th
    timeout             = var.lb_timeout
    interval            = var.lb_interval
  }
}


resource "aws_lb_listener" "mtc_lb_listener" {
  load_balancer_arn = aws_lb.mtc_lb.arn
  port              = var.lb_listener_port
  protocol          = var.lb_listener_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mtc_tg.arn
  }
}