################################################
# Load Balancer
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer
################################################

output "load_balancer_id" {
  description = "Unique ID of the Load Balancer."
  value       = module.lb.load_balancer_id
}

output "load_balancer_name" {
  description = "Name of the Load Balancer."
  value       = module.lb.load_balancer_name
}

output "load_balancer_type" {
  description = "Type of the Load Balancer."
  value       = module.lb.load_balancer_type
}

output "load_balancer_location" {
  description = "The location name of the Load Balancer. Require when no network_zone is set."
  value       = module.lb.load_balancer_location
}

output "load_balancer_first_network_id" {
  description = "ID of the first private network that this Load Balancer is connected to."
  value       = module.lb.load_balancer_first_network_id
}

output "load_balancer_first_network_ip" {
  description = "IP of the Load Balancer in the first private network that it is connected to."
  value       = module.lb.load_balancer_first_network_ip
}

output "load_balancer_ipv4" {
  description = "IPv4 Address of the Load Balancer."
  value       = module.lb.load_balancer_ipv4
}

output "load_balancer_ipv6" {
  description = "IPv6 Address of the Load Balancer."
  value       = module.lb.load_balancer_ipv6
}

output "load_balancer_algorithm" {
  description = "Configuration of the algorithm the Load Balancer use."
  value       = module.lb.load_balancer_algorithm
}

output "load_balancer_labels" {
  description = "User-defined labels (key-value pairs) should be created with."
  value       = module.lb.load_balancer_labels
}

output "load_balancer_delete_protection" {
  description = "Enable or disable delete protection."
  value       = module.lb.load_balancer_delete_protection
}
