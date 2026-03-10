variable "key_pair_name" {
  type        = string
  description = <<EOF
The name of the ssh key referenced in openstack
EOF
}

variable "user_data" {
  type        = string
  default     = null
  description = "The user data for instance"
}

variable "image_id" {
  type = string

  description = <<EOF
The image's id referenced in openstack
EOF
}

variable "name" {
  type        = string
  description = <<EOF
Instance's name
EOF
}

variable "flavor_name" {
  type        = string
  description = <<EOF
Instance's flavor name referenced in openstack
EOF
}

variable "public_ip_network" {
  type        = string
  description = <<EOF
The name of the network who give floating IPs
EOF
  default     = null
}

variable "ports" {
  type = list(object({
    name               = string
    network_id         = string
    subnet_id          = string
    admin_state_up     = optional(bool, true)
    security_group_ids = optional(list(string), [])
    ip_address         = optional(string)
    port_security      = optional(bool, true)
    no_security_groups = optional(bool, false)
    description        = optional(string)
    dns_name           = optional(string)
    qos_policy_id      = optional(string)
    allowed_address_pairs = optional(list(object({
      ip_address  = string
      mac_address = optional(string)
    })), [])
    extra_dhcp_options = optional(list(object({
      name       = string
      value      = string
      ip_version = optional(number, 4)
    })), [])
    tags = optional(list(string), [])
  }))
  default = [
    {
      name                  = ""
      network_id            = ""
      subnet_id             = ""
      admin_state_up        = true
      security_group_ids    = []
      ip_address            = null
      port_security         = true
      no_security_groups    = false
      description           = null
      dns_name              = null
      qos_policy_id         = null
      allowed_address_pairs = []
      extra_dhcp_options    = []
      tags                  = []
    }
  ]
  description = "The ports list, at least 1 port is required"
}

variable "block_device_volume_size" {
  type        = number
  description = <<EOF
The volume size of block device
EOF
  default     = 20
}

variable "block_device_delete_on_termination" {
  type        = bool
  description = <<EOF
Delete block device when instance is shut down
EOF
  default     = true
}

variable "volume_type" {
  type        = string
  description = "The type of volume to use, e.g., 'ceph-ssd', 'kz-ala-1-san-nvme-h1' or 'ceph-hdd'"
  default     = "ceph-ssd"
}

variable "server_groups" {
  type        = list(string)
  description = <<EOF
List of server group id
EOF
  default     = []
}

variable "tags" {
  type        = list(string)
  default     = null
  description = "The instances tags"
}

# Added all information about metadata;

variable "metadata" {
  type        = map(string)
  description = <<-EOF
  Metadata for the OpenStack instance, used for categorization and identification of the service across environments and projects:
  - environment: Specifies the deployment environment (e.g., "dev", "staging", "prod", "infra") to indicate where the instance is used.
  - project: Defines the project name or identifier associated with this instance (e.g., "tesla"), useful for organizing and filtering resources within larger environments.
  - service_type: Describes the type of service provided by this instance (e.g., "runner", "database", "web"), helping to classify the role of the instance in the architecture.
  - service_name: A unique name for the specific service this instance runs (e.g., "tesla_runner_infra"), enabling more granular tracking and management of resources.
  - service_role: Defines the role of the instance within the service (e.g., "master", "worker", "backup"), useful for distributed or clustered services with distinct roles.
  These metadata fields allow for more effective resource organization, monitoring, and automated management within OpenStack and other third-party integrations.
  EOF
  default = {
    environment  = null
    project      = null
    service_type = null
    service_name = null
    service_role = null
  }
}

# Added additional region info for volume
variable "region" {
  type        = string
  default     = ""
  description = "Region where volume's located."
}

# Added additional AZ info for volume
variable "availability_zone" {
  type        = string
  default     = ""
  description = "AZ where volume's available."
}

variable "power_state" {
  type        = string
  default     = "active"
  description = "The VM state. Only 'active', 'shutoff', 'paused' and 'shelved_offloaded' are supported values."
}

variable "force_delete" {
  type        = bool
  default     = false
  description = "Whether to force the OpenStack instance to be forcefully deleted."
}

variable "stop_before_destroy" {
  type        = bool
  default     = false
  description = "Whether to try stop instance gracefully before destroying it."
}

variable "block_device_description" {
  type        = string
  default     = null
  description = "The description of the block device."
}

variable "block_device_metadata" {
  type        = map(string)
  default     = {}
  description = "Metadata key/value pairs to associate with the volume."
}

variable "snapshot_id" {
  type        = string
  default     = null
  description = "The snapshot ID from which to create the volume."
}

variable "source_vol_id" {
  type        = string
  default     = null
  description = "The volume ID from which to create the volume."
}

variable "backup_id" {
  type        = string
  default     = null
  description = "The backup ID from which to create the volume."
}

variable "block_device_scheduler_hints" {
  type        = any
  default     = null
  description = "Provide the Cinder scheduler with hints on where to instantiate a volume."
}

variable "fip_description" {
  type        = string
  default     = null
  description = "Human-readable description for the floating IP."
}

variable "fip_dns_name" {
  type        = string
  default     = null
  description = "The floating IP DNS name."
}

variable "fip_dns_domain" {
  type        = string
  default     = null
  description = "The floating IP DNS domain."
}

variable "instance_availability_zone" {
  type        = string
  default     = null
  description = "The availability zone in which to create the server."
}

variable "vendor_options" {
  type = object({
    ignore_resize_confirmation  = optional(bool, false)
    detach_ports_before_destroy = optional(bool, false)
  })
  default     = null
  description = "Vendor-specific options for the instance."
}

variable "personalities" {
  type = list(object({
    file    = string
    content = string
  }))
  default     = []
  description = "A list of files to inject into the instance at boot time."
}

variable "extra_volumes" {
  type = list(object({
    volume_id = string
    device    = optional(string)
  }))
  default     = []
  description = "A list of additional volumes to attach to the instance."
}

variable "floating_ip_port_index" {
  type        = number
  default     = 0
  description = "The index of the port to associate the floating IP with (0 for main port, 1+ for additional ports)."
}