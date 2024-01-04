# Create Target group for stage load balancer
resource "aws_lb_target_group" "target_group" {
  name     = "Stage-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_name
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }
}

# Create stage load balancer listener
resource "aws_lb_listener" "LB_listener" {
  load_balancer_arn = aws_lb.stage_LB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

# Create stage load balancer
resource "aws_lb" "stage_LB" {
  name                       = var.stage-lb-name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.vpc_SG_ids
  subnets                    = var.subnet_id
  enable_deletion_protection = false
  tags = {
    Name = var.stage-lb-name
  }
}

# Create Target group for Production load balancer
resource "aws_lb_target_group" "prod_lb_target_group" {
  name     = "prod-target-group"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_name
  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 5
    interval            = 30
    timeout             = 5
  }
}

# # Create Production load balancer listener
# resource "aws_lb_listener" "prod_LB_listener" {
#   load_balancer_arn = aws_lb.Prod_LB.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.cert_arn
#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.prod_lb_target_group.arn
#   }
# }

# Create Production load balancer listener 2
resource "aws_lb_listener" "prod_LB_listener2" {
  load_balancer_arn = aws_lb.Prod_LB.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.prod_lb_target_group.arn
  }
}

# Create Production load balancer
resource "aws_lb" "Prod_LB" {
  name                       = var.Prod-lb-name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.vpc_SG_ids
  subnets                    = var.subnet_id
  enable_deletion_protection = false
  tags = {
    Name = var.Prod-lb-name
  }
}