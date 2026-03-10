# Create volume for instance boot
resource "openstack_blockstorage_volume_v3" "volume_os" {
  name                 = var.name
  size                 = var.block_device_volume_size
  volume_type          = var.volume_type
  image_id             = var.image_id
  enable_online_resize = true
  region               = var.region == null ? null : var.region
  availability_zone    = var.availability_zone == null ? null : var.availability_zone
  description          = var.block_device_description
  metadata             = var.block_device_metadata
  snapshot_id          = var.snapshot_id
  source_vol_id        = var.source_vol_id
  backup_id            = var.backup_id

  dynamic "scheduler_hints" {
    for_each = var.block_device_scheduler_hints != null ? [var.block_device_scheduler_hints] : []
    content {
      different_host    = lookup(scheduler_hints.value, "different_host", null)
      same_host         = lookup(scheduler_hints.value, "same_host", null)
      local_to_instance = lookup(scheduler_hints.value, "local_to_instance", null)
      query             = lookup(scheduler_hints.value, "query", null)
    }
  }
}

# Create the main network port
resource "openstack_networking_port_v2" "main_port" {
  name               = var.ports[0].name
  network_id         = var.ports[0].network_id
  admin_state_up     = var.ports[0].admin_state_up
  security_group_ids = var.ports[0].no_security_groups ? null : var.ports[0].security_group_ids
  no_security_groups = var.ports[0].no_security_groups
  description        = var.ports[0].description
  dns_name           = var.ports[0].dns_name
  qos_policy_id      = var.ports[0].qos_policy_id

  fixed_ip {
    subnet_id  = var.ports[0].subnet_id
    ip_address = var.ports[0].ip_address
  }

  dynamic "allowed_address_pairs" {
    for_each = var.ports[0].allowed_address_pairs
    content {
      ip_address  = allowed_address_pairs.value.ip_address
      mac_address = allowed_address_pairs.value.mac_address
    }
  }

  dynamic "extra_dhcp_option" {
    for_each = var.ports[0].extra_dhcp_options
    content {
      name       = extra_dhcp_option.value.name
      value      = extra_dhcp_option.value.value
      ip_version = lookup(extra_dhcp_option.value, "ip_version", 4)
    }
  }

  port_security_enabled = var.ports[0].port_security
  tags                  = var.ports[0].tags
}

# Create instance
resource "openstack_compute_instance_v2" "instance" {
  name        = var.name
  flavor_name = var.flavor_name

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_os.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = var.block_device_delete_on_termination
  }

  key_pair = var.key_pair_name

  config_drive = true
  user_data    = var.user_data

  # Attach the main port to the instance
  network {
    port = openstack_networking_port_v2.main_port.id
  }

  # Metadata block: combines existing OpenStack metadata with custom metadata
  metadata = { for key, value in var.metadata : key => value if value != null }

  dynamic "scheduler_hints" {
    for_each = var.server_groups
    content {
      group = scheduler_hints.value
    }
  }

  availability_zone   = var.instance_availability_zone
  power_state         = var.power_state
  force_delete        = var.force_delete
  stop_before_destroy = var.stop_before_destroy

  dynamic "vendor_options" {
    for_each = var.vendor_options != null ? [var.vendor_options] : []
    content {
      ignore_resize_confirmation  = lookup(vendor_options.value, "ignore_resize_confirmation", false)
      detach_ports_before_destroy = lookup(vendor_options.value, "detach_ports_before_destroy", false)
    }
  }

  dynamic "personality" {
    for_each = var.personalities
    content {
      file    = personality.value.file
      content = personality.value.content
    }
  }

  tags = var.tags
}

# Create additional ports if provided
resource "openstack_networking_port_v2" "additional_ports" {
  count = length(var.ports) > 1 ? length(var.ports) - 1 : 0

  name               = var.ports[count.index + 1].name
  network_id         = var.ports[count.index + 1].network_id
  admin_state_up     = var.ports[count.index + 1].admin_state_up
  security_group_ids = var.ports[count.index + 1].no_security_groups ? null : var.ports[count.index + 1].security_group_ids
  no_security_groups = var.ports[count.index + 1].no_security_groups
  description        = var.ports[count.index + 1].description
  dns_name           = var.ports[count.index + 1].dns_name
  qos_policy_id      = var.ports[count.index + 1].qos_policy_id

  fixed_ip {
    subnet_id  = var.ports[count.index + 1].subnet_id
    ip_address = var.ports[count.index + 1].ip_address
  }

  dynamic "allowed_address_pairs" {
    for_each = var.ports[count.index + 1].allowed_address_pairs
    content {
      ip_address  = allowed_address_pairs.value.ip_address
      mac_address = allowed_address_pairs.value.mac_address
    }
  }

  dynamic "extra_dhcp_option" {
    for_each = var.ports[count.index + 1].extra_dhcp_options
    content {
      name       = extra_dhcp_option.value.name
      value      = extra_dhcp_option.value.value
      ip_version = lookup(extra_dhcp_option.value, "ip_version", 4)
    }
  }

  port_security_enabled = var.ports[count.index + 1].port_security
  tags                  = var.ports[count.index + 1].tags
}

# Attach additional ports to the instance
resource "openstack_compute_interface_attach_v2" "attached_ports" {
  count       = length(var.ports) > 1 ? length(var.ports) - 1 : 0
  instance_id = openstack_compute_instance_v2.instance.id
  port_id     = openstack_networking_port_v2.additional_ports[count.index].id
}

# Attach extra volumes if provided
resource "openstack_compute_volume_attach_v2" "extra_volumes" {
  count       = length(var.extra_volumes)
  instance_id = openstack_compute_instance_v2.instance.id
  volume_id   = var.extra_volumes[count.index].volume_id
  device      = var.extra_volumes[count.index].device
}

# Create floating IP
resource "openstack_networking_floatingip_v2" "ip" {
  count = var.public_ip_network == null ? 0 : 1

  pool        = var.public_ip_network
  description = var.fip_description
  dns_name    = var.fip_dns_name
  dns_domain  = var.fip_dns_domain
}

# Attach floating IP to the specified port (default to main port at index 0)
resource "openstack_networking_floatingip_associate_v2" "ipa" {
  count       = var.public_ip_network == null ? 0 : 1
  floating_ip = openstack_networking_floatingip_v2.ip[count.index].address
  port_id = var.floating_ip_port_index == 0 ? openstack_networking_port_v2.main_port.id : (
    length(openstack_networking_port_v2.additional_ports) >= var.floating_ip_port_index ? openstack_networking_port_v2.additional_ports[var.floating_ip_port_index - 1].id : null
  )
}