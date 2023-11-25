output "lb_dns" {
  value = aws_lb.node_alb.dns_name
}