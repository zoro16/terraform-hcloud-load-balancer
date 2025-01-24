################################################
# Load Balancer
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer
################################################

resource "hcloud_load_balancer" "load_balancer" {
  count = var.create_load_balancer ? 1 : 0

  name               = var.load_balancer_name
  load_balancer_type = var.load_balancer_type
  location           = var.load_balancer_location
  network_zone       = var.load_balancer_network_zone
  labels             = var.load_balancer_labels
  delete_protection  = var.load_balancer_delete_protection

  algorithm {
    type = var.load_balancer_algorithm_type
  }
}


################################################
# Load Balancer Network
#
# Add your Load Balancer to a Network to route traffic within that private network.
# For servers that are in the same private network as the Load Balancer,
# you can use private IPs to add the servers as targets.
#
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network
#
################################################

resource "hcloud_load_balancer_network" "lb_net" {
  count = var.create_load_balancer_network ? 1 : 0

  load_balancer_id        = var.load_balancer_network_load_balancer_id
  network_id              = var.load_balancer_network_network_id
  subnet_id               = var.load_balancer_network_subnet_id
  ip                      = var.load_balancer_network_ip
  enable_public_interface = var.load_balancer_network_enable_public_interface
}


################################################
# Load Balancer Target
#
# You can configure the Load Balancer according to your own needs.
# Simply add information about the protocol, source port and destination port.
#
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target
################################################

resource "hcloud_load_balancer_target" "lb_target" {
  count = var.create_load_balancer_target ? 1 : 0

  type             = var.load_balancer_target_type
  load_balancer_id = var.load_balancer_target_load_balancer_id
  server_id        = var.load_balancer_target_server_id
  label_selector   = var.load_balancer_target_label_selector
  ip               = var.load_balancer_target_ip
  use_private_ip   = var.load_balancer_target_use_private_ip
}


################################################
# Load Balancer Service
#
# You can configure the Load Balancer according to your own needs.
# Simply add information about the protocol, source port and destination port.
# To view advanced settings, use the pencil symbol on the right.
#
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service
################################################

resource "hcloud_load_balancer_service" "lb_service" {
  count = var.create_load_balancer_service ? 1 : 0

  load_balancer_id = var.load_balancer_service_load_balancer_id
  protocol         = var.load_balancer_service_protocol
  listen_port      = var.load_balancer_service_listen_port
  destination_port = var.load_balancer_service_destination_port
  proxyprotocol    = var.load_balancer_service_proxyprotocol

  dynamic "http" {
    for_each = var.load_balancer_service_http

    content {
      sticky_sessions = http.value.sticky_sessions
      cookie_name     = http.value.cookie_name
      cookie_lifetime = http.value.cookie_lifetime
      certificates    = http.value.certificates
      redirect_http   = http.value.redirect_http
    }
  }

  dynamic "health_check" {
    for_each = var.load_balancer_service_health_check

    content {
      protocol = health_check.value.protocol
      port     = health_check.value.port
      interval = health_check.value.interval
      timeout  = health_check.value.timeout
      retries  = health_check.value.retries

      dynamic "http" {
        for_each = health_check.value.http

        content {
          domain       = http.value.domain
          path         = http.value.path
          response     = http.value.response
          tls          = http.value.tls
          status_codes = http.value.status_codes
        }
      }
    }

  }
}
