output "stage_lb_dns" {
  value = aws_lb.stage_LB.dns_name
}
output "stage_zone_id" {
  value = aws_lb.stage_LB.zone_id
}
output "Stage_arn" {
  value = aws_lb.stage_LB.arn
}
output "stage_tg_arn" {
  value = aws_lb_target_group.target_group.arn
}
output "Prod_lb_dns" {
  value = aws_lb.Prod_LB.dns_name
}
output "Prod_zone_id" {
  value = aws_lb.Prod_LB.zone_id
}
output "Prod_arn" {
  value = aws_lb.Prod_LB.arn
}
output "Prod_tg_arn" {
  value = aws_lb_target_group.prod_lb_target_group.arn
}