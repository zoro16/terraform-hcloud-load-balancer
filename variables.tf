################################################
# Load Balancer
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer
################################################

variable "create_load_balancer" {
  description = "Whether to create a Load Balancer or not."
  type        = bool
  default     = false
}

variable "load_balancer_name" {
  description = "Name of the Load Balancer."
  type        = string
  default     = null
}

variable "load_balancer_type" {
  description = "Type of the Load Balancer."
  type        = string
  default     = "lb11"

  validation {
    condition     = contains(["lb11", "lb21", "lb31"], var.load_balancer_type)
    error_message = "Please enter a valid Load Balancer Type e.g. lb11, lb21, lb31"
  }
}

variable "load_balancer_location" {
  description = "The location name of the Load Balancer. Require when no network_zone is set."
  type        = string
  default     = "nbg1-dc3"

  validation {
    condition     = can(regex("(fsn|nbg|hel|ash|hil|sin)[0-9]*", var.load_balancer_location))
    error_message = "Must have a vaild location name e.g. nbg1, fsn1, hel1, ash or hil."
  }
}

variable "load_balancer_network_zone" {
  description = "The Network Zone of the Load Balancer. Require when no location is set."
  type        = string
  default     = "eu-central"

  validation {
    condition     = contains(["eu-central", "us-west", "us-east", "ap-southeast"], var.load_balancer_network_zone) || length(var.load_balancer_network_zone) == 0
    error_message = "Wrong Network zone. Please enter a valid Network Zone e.g. `eu-central`, `us-west`, `us-east`, `ap-southeast`"
  }
}

variable "load_balancer_algorithm_type" {
  description = <<EOF
Configuration of the algorithm the Load Balancer use.
algorithm support the following fields:
    type - (Required, string) Type of the Load Balancer Algorithm. round_robin or least_connections
EOF
  type        = string
  default     = "round_robin"

  validation {
    condition     = contains(["round_robin", "least_connections"], var.load_balancer_algorithm_type)
    error_message = "Only `round_robin` and `least_connections` algorithms are supported. Please enter a valid algorithm."
  }
}

variable "load_balancer_labels" {
  description = "User-defined labels (key-value pairs) should be created with."
  type        = map(any)
  default     = {}
}

variable "load_balancer_delete_protection" {
  description = "Enable or disable delete protection."
  type        = bool
  default     = false
}


################################################
# Load Balancer Network
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_network
################################################

variable "create_load_balancer_network" {
  description = "Whether to create a Load Balancer Network or not."
  type        = bool
  default     = false
}

variable "load_balancer_network_load_balancer_id" {
  description = "ID of the Load Balancer."
  type        = number
  default     = null
}

variable "load_balancer_network_network_id" {
  description = "ID of the network which should be added to the Load Balancer. Required if `subnet_id` is not set. Successful creation of the resource depends on the existence of a subnet in the Hetzner Cloud Backend. Using `network_id` will not create an explicit dependency between the Load Balancer and the subnet. Therefore `depends_on` may need to be used. Alternatively the `subnet_id` property can be used, which will create an explicit dependency between `hcloud_load_balancer_network` and the existence of a subnet."
  type        = number
  default     = null
}

variable "load_balancer_network_subnet_id" {
  description = "ID of the sub-network which should be added to the Load Balancer. Required if `network_id` is not set. Note: if the `ip` property is missing, the Load Balancer is currently added to the last created subnet."
  type        = string
  default     = null
}

variable "load_balancer_network_ip" {
  description = "IP to request to be assigned to this Load Balancer. If you do not provide this then you will be auto assigned an IP address."
  type        = string
  default     = null
}

variable "load_balancer_network_enable_public_interface" {
  description = "Enable or disable the Load Balancers public interface."
  type        = bool
  default     = true
}


################################################
# Load Balancer Target
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_target
################################################


variable "create_load_balancer_target" {
  description = "Whether to create a Load Balancer Target or not."
  type        = bool
  default     = false
}

variable "load_balancer_target_type" {
  description = <<EOF
Type of the target. Possible values `server`, `label_selector`, `ip`."
`server` => VM Server
`label_selector` => All servers that match this label query will be used as a target.
`ip` => Dedicated Server (root) IP address
EOF
  type        = string
  default     = "server"

  validation {
    condition     = contains(["server", "label_selector", "ip"], var.load_balancer_target_type)
    error_message = "Wrong Load Balancer Target type. Please enter a valid Load Balancer Target type e.g. `server`, `label_selector`, `ip`"
  }
}

variable "load_balancer_target_load_balancer_id" {
  description = "ID of the Load Balancer to which the target gets attached."
  type        = string
  default     = null
}

variable "load_balancer_target_server_id" {
  description = "ID of the server which should be a target for this Load Balancer. Required if type is server"
  type        = number
  default     = null
}

variable "load_balancer_target_label_selector" {
  description = "Label Selector selecting targets for this Load Balancer. Required if type is label_selector."
  type        = string
  default     = null
}

variable "load_balancer_target_ip" {
  description = "IP address for an IP Target. Required if type is ip."
  type        = string
  default     = null
}

variable "load_balancer_target_use_private_ip" {
  description = "Use the private IP to connect to Load Balancer targets. Only allowed if type is server or label_selector."
  type        = bool
  default     = null
}


################################################
# Load Balancer Service
# https://registry.terraform.io/providers/hetznercloud/hcloud/latest/docs/resources/load_balancer_service
################################################

variable "create_load_balancer_service" {
  description = "Whether to create a Load Balancer Service or not."
  type        = bool
  default     = false
}

variable "load_balancer_service_load_balancer_id" {
  description = "Id of the load balancer this service belongs to."
  type        = string
  default     = null
}

variable "load_balancer_service_protocol" {
  description = "Protocol of the service. http, https or tcp"
  type        = string
  default     = "http"

  validation {
    condition     = contains(["http", "https", "tcp"], var.load_balancer_service_protocol)
    error_message = "Wrong Load Balancer Service protocol. Please enter a valid protocol e.g. `http`, `https`, `tcp`"
  }
}

variable "load_balancer_service_listen_port" {
  description = "Port the service listen on, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer."
  type        = number
  default     = 80

  validation {
    condition     = (var.load_balancer_service_listen_port >= 1) && (var.load_balancer_service_listen_port < 65536)
    error_message = "Listen Port is out of range. Please enter a valid Listen Port between 1-65535"
  }
}

variable "load_balancer_service_destination_port" {
  description = "Port the service connects to the targets on, required if protocol is tcp. Can be everything between 1 and 65535."
  type        = number
  default     = 80

  validation {
    condition     = (var.load_balancer_service_destination_port >= 1) && (var.load_balancer_service_destination_port < 65536)
    error_message = "Destination Port is out of range. Please enter a valid Destination Port between 1-65535"
  }
}

variable "load_balancer_service_proxyprotocol" {
  description = "Whether to enable proxyprotocol or not."
  type        = bool
  default     = false
}

variable "load_balancer_service_http" {
  description = "List of http configurations when protocol is http or https."
  type = list(object({
    # Enable sticky sessions
    sticky_sessions = optional(bool)

    # Name of the cookie for sticky session. Default: HCLBSTICKY
    cookie_name = optional(string)

    # Lifetime of the cookie for sticky session (in seconds). Default: 300
    cookie_lifetime = optional(number)

    # List of IDs from certificates which the Load Balancer has.
    certificates = optional(list(number))

    # Redirect HTTP to HTTPS traffic. Only supported for services with protocol https using the default HTTP port 80.
    redirect_http = optional(bool)

  }))
  default = null
}

variable "load_balancer_service_health_check" {
  description = "List of health check configurations when protocol is http or https."
  type = list(object({
    # (Required) Protocol the health check uses. http or tcp
    protocol = optional(string)

    # (Required) Port the health check tries to connect to, required if protocol is tcp. Can be everything between 1 and 65535. Must be unique per Load Balancer.
    port = optional(number)

    # (Required)Interval how often the health check will be performed, in seconds.
    interval = optional(number)

    # (Required) Timeout when a health check try will be canceled if there is no response, in seconds.
    timeout = optional(number)

    # Number of tries a health check will be performed until a target will be listed as unhealthy.
    retries = optional(number)

    # List of http configurations. Required if protocol is http.
    http = optional(list(object({
      # Domain we try to access when performing the Health Check.
      domain = optional(string)

      # Path we try to access when performing the Health Check.
      path = optional(string)

      # Response we expect to be included in the Target response when a Health Check was performed.
      response = optional(string)

      # Enable TLS certificate checking.
      tls = optional(bool)

      # We expect that the target answers with these status codes. If not the target is marked as unhealthy.
      status_codes = optional(list(string))
    })))

  }))
  default = null
}
