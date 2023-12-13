# Creating stage launch template
resource "aws_launch_template" "stage_LT" {
  name_prefix = var.stage_lt_name
  image_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.lt_sg
  key_name = var.key_name
  user_data = base64decode(templatefile("${path.root}/module/autoscaling/stage_script.sh",{
    var1=var.nexus_ip,
    newrelic_license_key = var.newrelic_license_key,
    acct_id = var.acct_id
  }))
}

#Creating stage Autoscaling Group
resource "aws_autoscaling_group" "stage_asg" {
  name = var.stage_asg_name
  max_size = 3
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 120
  health_check_type = "EC2"
  force_delete = true
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns = var.stage_tg_arn
  launch_template {
    id = aws_launch_template.stage_LT.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "stage-instance"
    propagate_at_launch = true
  }
}

# Creating stage ASG Policy
resource "aws_autoscaling_policy" "stage_asg_policy" {
  name = var.stage_asg_policy_type
  adjustment_type = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.stage_asg.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}

# Creating prod launch template
resource "aws_launch_template" "prod_LT" {
  name_prefix = var.prod_lt_name
  image_id = var.ami_id
  instance_type = var.instance_type
  vpc_security_group_ids = var.lt_sg
  key_name = var.key_name
  user_data = base64decode(templatefile("${path.root}/module/autoscaling/prod_script.sh",{
    var1=var.nexus_ip,
    newrelic_license_key = var.newrelic_license_key,
    acct_id = var.acct_id
  }))
}

#Creating prod Autoscaling Group
resource "aws_autoscaling_group" "prod_asg" {
  name = var.prod_asg_name
  max_size = 3
  min_size = 1
  desired_capacity = 2
  health_check_grace_period = 120
  health_check_type = "EC2"
  force_delete = true
  vpc_zone_identifier = var.vpc_zone_identifier
  target_group_arns = var.prod_tg_arn
  launch_template {
    id = aws_launch_template.prod_LT.id
    version = "$Latest"
  }
  tag {
    key = "Name"
    value = "prod-instance"
    propagate_at_launch = true
  }
}

# Creating prod ASG Policy
resource "aws_autoscaling_policy" "prod_asg_policy" {
  name = var.prod_asg_policy_type
  adjustment_type = "ChangeInCapacity"
  policy_type = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.prod_asg.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 80.0
  }
}