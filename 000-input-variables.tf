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
  type        = string
  default     = null
  description = "The image's id referenced in openstack"
}

variable "image_name" {
  type        = string
  default     = null
  description = "The image's name referenced in openstack"
}

variable "name" {
  type        = string
  description = <<EOF
Instance's name
EOF
}

variable "flavor_name" {
  type        = string
  default     = null
  description = "Instance's flavor name referenced in openstack"
}

variable "flavor_id" {
  type        = string
  default     = null
  description = "Instance's flavor id referenced in openstack"
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
    subnet_id          = optional(string)
    admin_state_up     = optional(bool, true)
    security_group_ids = optional(list(string), [])
    fixed_ips = optional(list(object({
      subnet_id  = optional(string)
      ip_address = optional(string)
    })), [])
    port_security      = optional(bool, true)
    no_security_groups = optional(bool, false)
    description        = optional(string)
    dns_name           = optional(string)
    qos_policy_id      = optional(string)
    mac_address        = optional(string)
    no_fixed_ip        = optional(bool, false)
    value_specs        = optional(map(string), {})
    allowed_address_pairs = optional(list(object({
      ip_address  = string
      mac_address = optional(string)
    })), [])
    extra_dhcp_options = optional(list(object({
      name       = string
      value      = string
      ip_version = optional(number, 4)
    })), [])
    binding = optional(object({
      host_id   = optional(string)
      vnic_type = optional(string)
      profile   = optional(string)
    }))
    tags = optional(list(string), [])
  }))
  default     = []
  description = "Ports attached at boot time (causes replacement on change). If empty, OpenStack will create a default port."
}

variable "hot_ports" {
  type = list(object({
    name               = string
    network_id         = string
    subnet_id          = optional(string)
    admin_state_up     = optional(bool, true)
    security_group_ids = optional(list(string), [])
    fixed_ips = optional(list(object({
      subnet_id  = optional(string)
      ip_address = optional(string)
    })), [])
    port_security      = optional(bool, true)
    no_security_groups = optional(bool, false)
    description        = optional(string)
    dns_name           = optional(string)
    qos_policy_id      = optional(string)
    mac_address        = optional(string)
    no_fixed_ip        = optional(bool, false)
    value_specs        = optional(map(string), {})
    allowed_address_pairs = optional(list(object({
      ip_address  = string
      mac_address = optional(string)
    })), [])
    extra_dhcp_options = optional(list(object({
      name       = string
      value      = string
      ip_version = optional(number, 4)
    })), [])
    binding = optional(object({
      host_id   = optional(string)
      vnic_type = optional(string)
      profile   = optional(string)
    }))
    tags = optional(list(string), [])
  }))
  default     = []
  description = "Ports attached after instance creation (hot-plug). Does not cause replacement."
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

variable "tags" {
  type        = list(string)
  default     = []
  description = "The instances tags"
}

variable "metadata" {
  type        = map(string)
  description = "Metadata for the OpenStack instance."
  default     = {}
}

variable "region" {
  type        = string
  default     = null
  description = "Region where volume's located."
}

variable "availability_zone" {
  type        = string
  default     = null
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

variable "instance_availability_zone_hints" {
  type        = string
  default     = null
  description = "The availability zone hints in which to create the server."
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
  description = "The index of the port to associate the floating IP with (0 for first boot-port, then hot-ports)."
}

variable "config_drive" {
  type        = bool
  default     = true
  description = "Whether to use the config_drive feature to configure the instance."
}

variable "admin_pass" {
  type        = string
  default     = null
  sensitive   = true
  description = "The administrative password to assign to the server."
}

variable "scheduler_hints" {
  type        = any
  default     = null
  description = "Provide the Nova scheduler with hints on where to instantiate an instance."
}

variable "hypervisor_hostname" {
  type        = string
  default     = null
  description = "Specifies the exact hypervisor hostname on which to create the instance."
}

variable "enable_online_resize" {
  type        = bool
  default     = true
  description = "When this option is set it allows extending attached volumes."
}

variable "consistency_group_id" {
  type        = string
  default     = null
  description = "The consistency group to place the volume in."
}

variable "source_replica" {
  type        = string
  default     = null
  description = "The volume ID to replicate with."
}

variable "volume_retype_policy" {
  type        = string
  default     = null
  description = "Migration policy when changing volume_type. 'never' or 'on-demand'."
}

variable "block_device_guest_format" {
  type        = string
  default     = null
  description = "Specifies the guest server disk file system format, such as ext4 or swap."
}

variable "block_device_device_type" {
  type        = string
  default     = null
  description = "The low-level device type that will be used (e.g., cdrom)."
}

variable "block_device_disk_bus" {
  type        = string
  default     = null
  description = "The low-level disk bus that will be used (e.g., virtio, scsi)."
}

variable "network_mode" {
  type        = string
  default     = null
  description = "Special string for 'network' option: 'auto' or 'none'. Conflicts with 'ports'."
}