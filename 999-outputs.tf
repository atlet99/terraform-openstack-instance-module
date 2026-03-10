# Output for instance IDs
output "instance_ids" {
  value       = [openstack_compute_instance_v2.instance.id]
  description = "Flat list of instance IDs."
}

# Consolidated list of all private IPs (boot + hot ports)
output "private_ips" {
  value = concat(
    [for port in openstack_networking_port_v2.boot_ports : port.fixed_ip[0].ip_address],
    [for port in openstack_networking_port_v2.hot_ports : port.fixed_ip[0].ip_address]
  )
  description = "Flat list of the first private IP address for all ports."
}

# All fixed IPs (all subnets, all ports)
output "all_fixed_ips" {
  value = concat(
    flatten([for port in openstack_networking_port_v2.boot_ports : port.fixed_ip[*].ip_address]),
    flatten([for port in openstack_networking_port_v2.hot_ports : port.fixed_ip[*].ip_address])
  )
  description = "Full list of all fixed IP addresses on all ports."
}

# Output for floating IPs
output "floating_ips" {
  value       = length(openstack_networking_floatingip_v2.ip) > 0 ? openstack_networking_floatingip_v2.ip[*].address : []
  description = "Flat list of floating IP addresses."
}

# Detailed list of all ports
output "instance_info" {
  value = concat(
    [
      for port in openstack_networking_port_v2.boot_ports : {
        id          = port.id
        name        = port.name
        type        = "boot"
        tags        = port.tags
        fixed_ips   = port.fixed_ip[*].ip_address
        mac_address = port.mac_address
        description = port.description
        binding     = port.binding
      }
    ],
    [
      for port in openstack_networking_port_v2.hot_ports : {
        id          = port.id
        name        = port.name
        type        = "hot"
        tags        = port.tags
        fixed_ips   = port.fixed_ip[*].ip_address
        mac_address = port.mac_address
        description = port.description
        binding     = port.binding
      }
    ]
  )
  description = "Detailed list of all ports (boot and hot) with tags, IPs, MAC addresses and binding info."
}

# Output for boot ports only
output "boot_ports" {
  value = [
    for port in openstack_networking_port_v2.boot_ports : {
      id        = port.id
      name      = port.name
      fixed_ips = port.fixed_ip[*].ip_address
    }
  ]
  description = "Details of ports attached at boot time."
}

# Output for hot ports only
output "hot_ports" {
  value = [
    for port in openstack_networking_port_v2.hot_ports : {
      id        = port.id
      name      = port.name
      fixed_ips = port.fixed_ip[*].ip_address
    }
  ]
  description = "Details of ports attached after boot (hot-plug)."
}

# Output for the root volume
output "root_volume_id" {
  value       = openstack_blockstorage_volume_v3.volume_os.id
  description = "The ID of the instance boot volume."
}

# Output for extra volume attachments
output "extra_volume_ids" {
  value       = var.extra_volumes[*].volume_id
  description = "List of IDs for additional volumes attached to the instance."
}

# Output for instance metadata
output "instance_metadata" {
  value       = openstack_compute_instance_v2.instance.metadata
  description = "The metadata associated with the instance."
}

# Output for availability zone info
output "availability_info" {
  value = {
    zone       = openstack_compute_instance_v2.instance.availability_zone
    zone_hints = openstack_compute_instance_v2.instance.availability_zone_hints
  }
  description = "Availability zone and hints for the instance."
}

# Sensitive admin password
output "admin_pass" {
  value       = openstack_compute_instance_v2.instance.admin_pass
  sensitive   = true
  description = "The administrative password assigned to the server."
}

# Access IPs
output "access_ip_v4" {
  value       = openstack_compute_instance_v2.instance.access_ip_v4
  description = "The first detected IPv4 address of the instance."
}

output "access_ip_v6" {
  value       = openstack_compute_instance_v2.instance.access_ip_v6
  description = "The first detected IPv6 address of the instance."
}

# All metadata (exported by OpenStack)
output "all_metadata" {
  value       = openstack_compute_instance_v2.instance.all_metadata
  description = "All metadata key/value pairs associated with the instance."
}

# All tags (exported by OpenStack)
output "all_tags" {
  value       = openstack_compute_instance_v2.instance.all_tags
  description = "All tags associated with the instance."
}

# Timestamps
output "created_at" {
  value       = openstack_compute_instance_v2.instance.created
  description = "The creation time of the instance."
}

output "updated_at" {
  value       = openstack_compute_instance_v2.instance.updated
  description = "The time when the instance was last updated."
}
