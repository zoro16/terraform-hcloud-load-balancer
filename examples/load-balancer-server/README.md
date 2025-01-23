# load-balancer-server

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | >= 1.42.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lb"></a> [lb](#module\_lb) | ../../ | n/a |
| <a name="module_net"></a> [net](#module\_net) | zoro16/network/hcloud | 1.0.0 |
| <a name="module_sv1"></a> [sv1](#module\_sv1) | zoro16/server/hcloud | 1.0.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | Hetzner Cloud API Token | `string` | n/a | yes |

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
| <a name="output_load_balancer_type"></a> [load\_balancer\_type](#output\_load\_balancer\_type) | Type of the Load Balancer. |
<!-- END_TF_DOCS -->
