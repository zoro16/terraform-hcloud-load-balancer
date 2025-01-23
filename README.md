## Description

Terraform module to provision `Load Balancer` resources in Hetzner Cloud.




## Usage

```hcl
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
```




<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.49.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_hcloud"></a> [hcloud](#provider\_hcloud) | >= 1.49.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [hcloud_load_balancer.load_balancer](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer) | resource |
| [hcloud_load_balancer_network.lb_net](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network) | resource |
| [hcloud_load_balancer_service.lb_service](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service) | resource |
| [hcloud_load_balancer_target.lb_target](https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create_load_balancer"></a> [create\_load\_balancer](#input\_create\_load\_balancer) | Whether to create a Load Balancer or not. | `bool` | `false` | no |
| <a name="input_create_load_balancer_network"></a> [create\_load\_balancer\_network](#input\_create\_load\_balancer\_network) | Whether to create a Load Balancer Network or not. | `bool` | `false` | no |
| <a name="input_create_load_balancer_service"></a> [create\_load\_balancer\_service](#input\_create\_load\_balancer\_service) | Whether to create a Load Balancer Service or not. | `bool` | `false` | no |
| <a name="input_create_load_balancer_target"></a> [create\_load\_balancer\_target](#input\_create\_load\_balancer\_target) | Whether to create a Load Balancer Target or not. | `bool` | `false` | no |
| <a name="input_load_balancer_algorithm_type"></a> [load\_balancer\_algorithm\_type](#input\_load\_balancer\_algorithm\_type) | Configuration of the algorithm the Load Balancer use.<br/>algorithm support the following fields:<br/>    type - (Required, string) Type of the Load Balancer Algorithm. round\_robin or least\_connections | `string` | `"round_robin"` | no |
| <a name="input_load_balancer_delete_protection"></a> [load\_balancer\_delete\_protection](#input\_load\_balancer\_delete\_protection) | Enable or disable delete protection. | `bool` | `false` | no |
| <a name="input_load_balancer_labels"></a> [load\_balancer\_labels](#input\_load\_balancer\_labels) | User-defined labels (key-value pairs) should be created with. | `map(any)` | `{}` | no |
| <a name="input_load_balancer_location"></a> [load\_balancer\_location](#input\_load\_balancer\_location) | The location name of the Load Balancer. Require when no network\_zone is set. | `string` | `"nbg1-dc3"` | no |
| <a name="input_load_balancer_name"></a> [load\_balancer\_name](#input\_load\_balancer\_name) | Name of the Load Balancer. | `string` | `null` | no |
| <a name="input_load_balancer_network_enable_public_interface"></a> [load\_balancer\_network\_enable\_public\_interface](#input\_load\_balancer\_network\_enable\_public\_interface) | Enable or disable the Load Balancers public interface. | `bool` | `true` | no |
| <a name="input_load_balancer_network_ip"></a> [load\_balancer\_network\_ip](#input\_load\_balancer\_network\_ip) | IP to request to be assigned to this Load Balancer. If you do not provide this then you will be auto assigned an IP address. | `string` | `null` | no |
| <a name="input_load_balancer_network_load_balancer_id"></a> [load\_balancer\_network\_load\_balancer\_id](#input\_load\_balancer\_network\_load\_balancer\_id) | ID of the Load Balancer. | `number` | `null` | no |
| <a name="input_load_balancer_network_network_id"></a> [load\_balancer\_network\_network\_id](#input\_load\_balancer\_network\_network\_id) | ID of the network which should be added to the Load Balancer. Required if `subnet_id` is not set. Successful creation of the resource depends on the existence of a subnet in the Hetzner Cloud Backend. Using `network_id` will not create an explicit dependency between the Load Balancer and the subnet. Therefore `depends_on` may need to be used. Alternatively the `subnet_id` property can be used, which will create an explicit dependency between `hcloud_load_balancer_network` and the existence of a subnet. | `number` | `null` | no |
| <a name="input_load_balancer_network_subnet_id"></a> [load\_balancer\_network\_subnet\_id](#input\_load\_balancer\_network\_subnet\_id) | ID of the sub-network which should be added to the Load Balancer. Required if `network_id` is not set. Note: if the `ip` property is missing, the Load Balancer is currently added to the last created subnet. | `string` | `null` | no |
| <a name="input_load_balancer_network_zone"></a> [load\_balancer\_network\_zone](#input\_load\_balancer\_network\_zone) | The Network Zone of the Load Balancer. Require when no location is set. | `string` | `"eu-central"` | no |
| <a name="input_load_balancer_service_destination_port"></a> [load\_balancer\_service\_destination\_port](#input\_load\_balancer\_service\_destination\_port) | Port the service connects to the targets on, required if protocol is tcp. Can be everything between 1 and 65535. | `number` | `80` | no |
| <a name="input_load_balancer_service_health_check"></a> [load\_balancer\_service\_health\_check](#input\_load\_balancer\_service\_health\_check) | List of health check configurations when protocol is http or https. | <pre>list(object({<br/>    # (Required) Protocol the health check uses. http or tcp<br/>    protocol = optional(string)<br/><br/>    # (Required) Port the health check tries to connect to, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer.<br/>    port = optional(number)<br/><br/>    # (Required)Interval how often the health check will be performed, in seconds.<br/>    interval = optional(number)<br/><br/>    # (Required) Timeout when a health check try will be canceled if there is no response, in seconds.<br/>    timeout = optional(number)<br/><br/>    # Number of tries a health check will be performed until a target will be listed as unhealthy.<br/>    retries = optional(number)<br/><br/>    # List of http configurations. Required if protocol is http.<br/>    http = optional(list(object({<br/>      # Domain we try to access when performing the Health Check.<br/>      domain = optional(string)<br/><br/>      # Path we try to access when performing the Health Check.<br/>      path = optional(string)<br/><br/>      # Response we expect to be included in the Target response when a Health Check was performed.<br/>      response = optional(string)<br/><br/>      # Enable TLS certificate checking.<br/>      tls = optional(bool)<br/><br/>      # We expect that the target answers with these status codes. If not the target is marked as unhealthy.<br/>      status_codes = optional(list(string))<br/>    })))<br/><br/>  }))</pre> | `null` | no |
| <a name="input_load_balancer_service_http"></a> [load\_balancer\_service\_http](#input\_load\_balancer\_service\_http) | List of http configurations when protocol is http or https. | <pre>list(object({<br/>    # Enable sticky sessions<br/>    sticky_sessions = optional(bool)<br/><br/>    # Name of the cookie for sticky session. Default: HCLBSTICKY<br/>    cookie_name = optional(string)<br/><br/>    # Lifetime of the cookie for sticky session (in seconds). Default: 300<br/>    cookie_lifetime = optional(number)<br/><br/>    # List of IDs from certificates which the Load Balancer has.<br/>    certificates = optional(list(number))<br/><br/>    # Redirect HTTP to HTTPS traffic. Only supported for services with protocol https using the default HTTP port 80.<br/>    redirect_http = optional(bool)<br/><br/>  }))</pre> | `null` | no |
| <a name="input_load_balancer_service_listen_port"></a> [load\_balancer\_service\_listen\_port](#input\_load\_balancer\_service\_listen\_port) | Port the service listen on, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer. | `number` | `80` | no |
| <a name="input_load_balancer_service_load_balancer_id"></a> [load\_balancer\_service\_load\_balancer\_id](#input\_load\_balancer\_service\_load\_balancer\_id) | Id of the load balancer this service belongs to. | `string` | `null` | no |
| <a name="input_load_balancer_service_protocol"></a> [load\_balancer\_service\_protocol](#input\_load\_balancer\_service\_protocol) | Protocol of the service. http, https or tcp | `string` | `"http"` | no |
| <a name="input_load_balancer_service_proxyprotocol"></a> [load\_balancer\_service\_proxyprotocol](#input\_load\_balancer\_service\_proxyprotocol) | Whether to enable proxyprotocol or not. | `bool` | `false` | no |
| <a name="input_load_balancer_target_ip"></a> [load\_balancer\_target\_ip](#input\_load\_balancer\_target\_ip) | IP address for an IP Target. Required if type is ip. | `string` | `null` | no |
| <a name="input_load_balancer_target_label_selector"></a> [load\_balancer\_target\_label\_selector](#input\_load\_balancer\_target\_label\_selector) | Label Selector selecting targets for this Load Balancer. Required if type is label\_selector. | `string` | `null` | no |
| <a name="input_load_balancer_target_load_balancer_id"></a> [load\_balancer\_target\_load\_balancer\_id](#input\_load\_balancer\_target\_load\_balancer\_id) | ID of the Load Balancer to which the target gets attached. | `string` | `null` | no |
| <a name="input_load_balancer_target_server_id"></a> [load\_balancer\_target\_server\_id](#input\_load\_balancer\_target\_server\_id) | ID of the server which should be a target for this Load Balancer. Required if type is server | `number` | `null` | no |
| <a name="input_load_balancer_target_type"></a> [load\_balancer\_target\_type](#input\_load\_balancer\_target\_type) | Type of the target. Possible values `server`, `label_selector`, `ip`."<br/>`server` => VM Server<br/>`label_selector` => All servers that match this label query will be used as a target.<br/>`ip` => Dedicated Server (root) IP address | `string` | `"server"` | no |
| <a name="input_load_balancer_target_use_private_ip"></a> [load\_balancer\_target\_use\_private\_ip](#input\_load\_balancer\_target\_use\_private\_ip) | Use the private IP to connect to Load Balancer targets. Only allowed if type is server or label\_selector. | `bool` | `null` | no |
| <a name="input_load_balancer_type"></a> [load\_balancer\_type](#input\_load\_balancer\_type) | Type of the Load Balancer. | `string` | `"lb11"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_load_balancer_algorithm"></a> [load\_balancer\_algorithm](#output\_load\_balancer\_algorithm) | Configuration of the algorithm the Load Balancer use. |
| <a name="output_load_balancer_delete_protection"></a> [load\_balancer\_delete\_protection](#output\_load\_balancer\_delete\_protection) | Enable or disable delete protection. |
| <a name="output_load_balancer_first_network_id"></a> [load\_balancer\_first\_network\_id](#output\_load\_balancer\_first\_network\_id) | ID of the first private network that this Load Balancer is connected to. |
| <a name="output_load_balancer_first_network_ip"></a> [load\_balancer\_first\_network\_ip](#output\_load\_balancer\_first\_network\_ip) | IP of the Load Balancer in the first private network that it is connected to. |
| <a name="output_load_balancer_id"></a> [load\_balancer\_id](#output\_load\_balancer\_id) | Unique ID of the Load Balancer. |
| <a name="output_load_balancer_ipv4"></a> [load\_balancer\_ipv4](#output\_load\_balancer\_ipv4) | IPv4 Address of the Load Balancer. |
| <a name="output_load_balancer_ipv6"></a> [load\_balancer\_ipv6](#output\_load\_balancer\_ipv6) | IPv6 Address of the Load Balancer. |
| <a name="output_load_balancer_labels"></a> [load\_balancer\_labels](#output\_load\_balancer\_labels) | User-defined labels (key-value pairs) should be created with. |
| <a name="output_load_balancer_location"></a> [load\_balancer\_location](#output\_load\_balancer\_location) | The location name of the Load Balancer. Require when no network\_zone is set. |
| <a name="output_load_balancer_name"></a> [load\_balancer\_name](#output\_load\_balancer\_name) | Name of the Load Balancer. |
| <a name="output_load_balancer_network_id"></a> [load\_balancer\_network\_id](#output\_load\_balancer\_network\_id) | ID of the Load Balancer network. |
| <a name="output_load_balancer_network_load_balancer_id"></a> [load\_balancer\_network\_load\_balancer\_id](#output\_load\_balancer\_network\_load\_balancer\_id) | ID of the Load Balancer. |
| <a name="output_load_balancer_network_network_id"></a> [load\_balancer\_network\_network\_id](#output\_load\_balancer\_network\_network\_id) | ID of the network. |
| <a name="output_load_balancer_network_network_ip"></a> [load\_balancer\_network\_network\_ip](#output\_load\_balancer\_network\_network\_ip) | IP assigned to this Load Balancer. |
| <a name="output_load_balancer_service_destination_port"></a> [load\_balancer\_service\_destination\_port](#output\_load\_balancer\_service\_destination\_port) | Port the service connects to the targets on, required if protocol is tcp. Can be everything between 1 and 65535. |
| <a name="output_load_balancer_service_health_check"></a> [load\_balancer\_service\_health\_check](#output\_load\_balancer\_service\_health\_check) | List of health check configurations when protocol is http or https. |
| <a name="output_load_balancer_service_http"></a> [load\_balancer\_service\_http](#output\_load\_balancer\_service\_http) | List of http configurations when protocol is http or https. |
| <a name="output_load_balancer_service_listen_port"></a> [load\_balancer\_service\_listen\_port](#output\_load\_balancer\_service\_listen\_port) | Port the service listen on, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer. |
| <a name="output_load_balancer_service_protocol"></a> [load\_balancer\_service\_protocol](#output\_load\_balancer\_service\_protocol) | Protocol of the service. http, https or tcp |
| <a name="output_load_balancer_service_proxyprotocol"></a> [load\_balancer\_service\_proxyprotocol](#output\_load\_balancer\_service\_proxyprotocol) | Whether to enable proxyprotocol or not. |
| <a name="output_load_balancer_target_ip"></a> [load\_balancer\_target\_ip](#output\_load\_balancer\_target\_ip) | IP address for an IP Target. Required if type is ip. |
| <a name="output_load_balancer_target_label_selector"></a> [load\_balancer\_target\_label\_selector](#output\_load\_balancer\_target\_label\_selector) | Label Selector selecting targets for this Load Balancer. Required if type is label\_selector. |
| <a name="output_load_balancer_target_server_id"></a> [load\_balancer\_target\_server\_id](#output\_load\_balancer\_target\_server\_id) | ID of the server which should be a target for this Load Balancer. Required if type is server |
| <a name="output_load_balancer_target_type"></a> [load\_balancer\_target\_type](#output\_load\_balancer\_target\_type) | Type of the target. Possible values `server`, `label_selector`, `ip`. |
| <a name="output_load_balancer_target_use_private_ip"></a> [load\_balancer\_target\_use\_private\_ip](#output\_load\_balancer\_target\_use\_private\_ip) | Use the private IP to connect to Load Balancer targets. Only allowed if type is server or label\_selector. |
| <a name="output_load_balancer_type"></a> [load\_balancer\_type](#output\_load\_balancer\_type) | Type of the Load Balancer. |
<!-- END_TF_DOCS -->
