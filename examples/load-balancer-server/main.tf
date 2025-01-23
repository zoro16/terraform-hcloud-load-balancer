# Configure the Hetzner Cloud Provider
provider "hcloud" {
  token = var.hcloud_token
}

module "net" {
  source  = "zoro16/network/hcloud"
  version = "1.0.0"

  create_network = true

  network_name                     = "example-network"
  network_ip_cidr_range            = "10.100.0.0/16"
  network_delete_protection        = false
  network_expose_routes_to_vswitch = false
  network_labels = {
    name        = "example-network"
    environment = "dev"
  }
  create_subnet        = true
  subnet_type          = "cloud"
  subnet_ip_cidr_range = "10.100.0.0/24"
  subnet_network_zone  = "eu-central"
  subnet_network_id    = module.net.network_id
}


module "sv1" {
  source  = "zoro16/server/hcloud"
  version = "1.0.0"

  create_server = true

  server_name          = "sv1"
  placement_group_name = "sv1"
  labels = {
    environment = "dev"
    product     = "lb-servers"
  }
}

module "lb" {
  source = "../../"

  create_load_balancer = true

  load_balancer_name     = "my-lb"
  load_balancer_type     = "lb11"
  load_balancer_location = "nbg1"
  # load_balancer_network_zone = "eu-central"
  load_balancer_algorithm_type    = "least_connections"
  load_balancer_delete_protection = false
  load_balancer_labels = {
    type        = "demo"
    environment = "dev"
  }

  create_load_balancer_network           = true
  load_balancer_network_load_balancer_id = module.lb.load_balancer_id
  # load_balancer_network_network_id = module.net.network_id
  # load_balancer_network_ip = "10.100.1.5"
  load_balancer_network_subnet_id               = module.net.subnet_id
  load_balancer_network_enable_public_interface = true


  create_load_balancer_target           = true
  load_balancer_target_type             = "label_selector"
  load_balancer_target_load_balancer_id = module.lb.load_balancer_id
  # load_balancer_target_server_id = module.sv1.server_id
  load_balancer_target_label_selector = "product=lb-servers"
  # load_balancer_target_ip = "142.142.142.142"
  # load_balancer_target_use_private_ip = true

  create_load_balancer_service           = true
  load_balancer_service_load_balancer_id = module.lb.load_balancer_id
  load_balancer_service_protocol         = "http"
  load_balancer_service_listen_port      = 80
  load_balancer_service_destination_port = 80
  load_balancer_service_proxyprotocol    = false
  load_balancer_service_http = [
    {
      sticky_sessions = false
      cookie_name     = "HCLBSTICKY"
      cookie_lifetime = 300
      certificates    = []
      redirect_http   = false
    }
  ]
  load_balancer_service_health_check = [
    {
      protocol = "http"
      port     = 80
      interval = 5
      timeout  = 10
      retries  = 10
      http = [
        {
          domain       = "example.com"
          path         = "/healthz"
          response     = "Ok"
          tls          = false
          status_codes = ["200", "201"]
        }
      ]
    }
  ]

}
