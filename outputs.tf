output "kibana_url" {
  value       = "http://${aws_eip.ip.public_ip}:5601"
  description = "URL to your Kibana web page"
}
