################################################
# Load Balancer
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer
################################################

output "load_balancer_id" {
  description = "Unique ID of the Load Balancer."
  value       = try(hcloud_load_balancer.load_balancer[0].id, hcloud_load_balancer.load_balancer[*].id)
}

output "load_balancer_name" {
  description = "Name of the Load Balancer."
  value       = try(hcloud_load_balancer.load_balancer[0].name, hcloud_load_balancer.load_balancer[*].name)
}

output "load_balancer_type" {
  description = "Type of the Load Balancer."
  value       = try(hcloud_load_balancer.load_balancer[0].load_balancer_type, hcloud_load_balancer.load_balancer[*].load_balancer_type)
}

output "load_balancer_location" {
  description = "The location name of the Load Balancer. Require when no network_zone is set."
  value       = try(hcloud_load_balancer.load_balancer[0].location, hcloud_load_balancer.load_balancer[*].location)
}

output "load_balancer_first_network_id" {
  description = "ID of the first private network that this Load Balancer is connected to."
  value       = try(hcloud_load_balancer.load_balancer[0].network_id, hcloud_load_balancer.load_balancer[*].network_id)
}

output "load_balancer_first_network_ip" {
  description = "IP of the Load Balancer in the first private network that it is connected to."
  value       = try(hcloud_load_balancer.load_balancer[0].network_ip, hcloud_load_balancer.load_balancer[*].network_ip)
}

output "load_balancer_ipv4" {
  description = "IPv4 Address of the Load Balancer."
  value       = try(hcloud_load_balancer.load_balancer[0].ipv4, hcloud_load_balancer.load_balancer[*].ipv4)
}

output "load_balancer_ipv6" {
  description = "IPv6 Address of the Load Balancer."
  value       = try(hcloud_load_balancer.load_balancer[0].ipv6, hcloud_load_balancer.load_balancer[*].ipv6)
}

output "load_balancer_algorithm" {
  description = "Configuration of the algorithm the Load Balancer use."
  value       = try(hcloud_load_balancer.load_balancer[0].algorithm, hcloud_load_balancer.load_balancer[*].algorithm)
}

output "load_balancer_labels" {
  description = "User-defined labels (key-value pairs) should be created with."
  value       = try(hcloud_load_balancer.load_balancer[0].labels, hcloud_load_balancer.load_balancer[*].labels)
}

output "load_balancer_delete_protection" {
  description = "Enable or disable delete protection."
  value       = try(hcloud_load_balancer.load_balancer[0].delete_protection, hcloud_load_balancer.load_balancer[*].delete_protection)
}


################################################
# Load Balancer Network
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network
################################################

output "load_balancer_network_id" {
  description = "ID of the Load Balancer network."
  value       = try(hcloud_load_balancer_network.lb_net[0].id, hcloud_load_balancer_network.lb_net[*].id)
}

output "load_balancer_network_network_id" {
  description = "ID of the network."
  value       = try(hcloud_load_balancer_network.lb_net[0].network_id, hcloud_load_balancer_network.lb_net[*].network_id)
}

output "load_balancer_network_load_balancer_id" {
  description = "ID of the Load Balancer."
  value       = try(hcloud_load_balancer_network.lb_net[0].load_balancer_id, hcloud_load_balancer_network.lb_net[*].load_balancer_id)
}

output "load_balancer_network_network_ip" {
  description = "IP assigned to this Load Balancer."
  value       = try(hcloud_load_balancer_network.lb_net[0].ip, hcloud_load_balancer_network.lb_net[*].ip)
}


################################################
# Load Balancer Target
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target
################################################

output "load_balancer_target_type" {
  description = "Type of the target. Possible values `server`, `label_selector`, `ip`."
  value       = try(hcloud_load_balancer_target.lb_target[0].type, hcloud_load_balancer_target.lb_target[*].type)
}

output "load_balancer_target_server_id" {
  description = "ID of the server which should be a target for this Load Balancer. Required if type is server"
  value       = try(hcloud_load_balancer_target.lb_target[0].server_id, hcloud_load_balancer_target.lb_target[*].server_id)

  precondition {
    condition     = (var.load_balancer_target_type != "server" && var.load_balancer_target_server_id != null) ? false : true
    error_message = "Only allowed if type is `server`."
  }
}

output "load_balancer_target_label_selector" {
  description = "Label Selector selecting targets for this Load Balancer. Required if type is label_selector."
  value       = try(hcloud_load_balancer_target.lb_target[0].label_selector, hcloud_load_balancer_target.lb_target[*].label_selector)

  precondition {
    condition     = (var.load_balancer_target_type == "label_selector" && var.load_balancer_target_label_selector == null) ? false : true
    error_message = "Only allowed if type is `label_selector`."
  }
}

output "load_balancer_target_ip" {
  description = "IP address for an IP Target. Required if type is ip."
  value       = try(hcloud_load_balancer_target.lb_target[0].ip, hcloud_load_balancer_target.lb_target[*].ip)

  precondition {
    condition     = (var.load_balancer_target_type == "ip" && var.load_balancer_target_ip == null) ? false : true
    error_message = "Only allowed if type is `ip`."
  }
}

output "load_balancer_target_use_private_ip" {
  description = "Use the private IP to connect to Load Balancer targets. Only allowed if type is server or label_selector."
  value       = try(hcloud_load_balancer_target.lb_target[0].use_private_ip, hcloud_load_balancer_target.lb_target[*].use_private_ip)

  precondition {
    condition     = (!contains(["server", "labels_selector"], var.load_balancer_target_type) && var.load_balancer_target_use_private_ip != null) ? false : true
    error_message = "Only allowed if type is `server` or `label_selector`."
  }
}


# ################################################
# # Load Balancer Service
# # https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service
# ################################################

output "load_balancer_service_protocol" {
  description = "Protocol of the service. http, https or tcp"
  value       = try(hcloud_load_balancer_service.lb_service[0].protocol, hcloud_load_balancer_service.lb_service[*].protocol)
}

output "load_balancer_service_listen_port" {
  description = "Port the service listen on, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer."
  value       = try(hcloud_load_balancer_service.lb_service[0].listen_port, hcloud_load_balancer_service.lb_service[*].listen_port)
}

output "load_balancer_service_destination_port" {
  description = "Port the service connects to the targets on, required if protocol is tcp. Can be everything between 1 and 65535."
  value       = try(hcloud_load_balancer_service.lb_service[0].destination_port, hcloud_load_balancer_service.lb_service[*].destination_port)
}

output "load_balancer_service_proxyprotocol" {
  description = "Whether to enable proxyprotocol or not."
  value       = try(hcloud_load_balancer_service.lb_service[0].proxyprotocol, hcloud_load_balancer_service.lb_service[*].proxyprotocol)
}

output "load_balancer_service_http" {
  description = "List of http configurations when protocol is http or https."
  value       = flatten(hcloud_load_balancer_service.lb_service[*].http)

  precondition {
    condition     = (!contains(["http", "https"], var.load_balancer_service_protocol) && var.load_balancer_service_http != null) ? false : true
    error_message = "Protocol must be set to either `http` or `https` before setting this variable."
  }
}

output "load_balancer_service_health_check" {
  description = "List of health check configurations when protocol is http or https."
  value       = flatten(hcloud_load_balancer_service.lb_service[*].health_check)

  precondition {
    condition     = (!contains(["http", "https"], var.load_balancer_service_protocol) && var.load_balancer_service_health_check != null) ? false : true
    error_message = "Protocol must be set to either `http` or `https` before setting this variable."
  }
}
