# Create volume for instance boot
resource "openstack_blockstorage_volume_v3" "volume_os" {
  name                 = var.name
  size                 = var.block_device_volume_size
  volume_type          = var.volume_type
  image_id             = var.image_id != null ? var.image_id : null
  enable_online_resize = var.enable_online_resize
  region               = var.region == null ? null : var.region
  availability_zone    = var.availability_zone == null ? null : var.availability_zone
  description          = var.block_device_description
  metadata             = var.block_device_metadata
  snapshot_id          = var.snapshot_id
  source_vol_id        = var.source_vol_id
  backup_id            = var.backup_id
  consistency_group_id = var.consistency_group_id
  source_replica       = var.source_replica
  volume_retype_policy = var.volume_retype_policy

  dynamic "scheduler_hints" {
    for_each = var.block_device_scheduler_hints != null ? [var.block_device_scheduler_hints] : []
    content {
      different_host        = lookup(scheduler_hints.value, "different_host", null)
      same_host             = lookup(scheduler_hints.value, "same_host", null)
      local_to_instance     = lookup(scheduler_hints.value, "local_to_instance", null)
      query                 = lookup(scheduler_hints.value, "query", null)
      additional_properties = lookup(scheduler_hints.value, "additional_properties", null)
    }
  }
}

# Create boot ports (attached at creation time)
resource "openstack_networking_port_v2" "boot_ports" {
  count = length(var.ports)

  name               = var.ports[count.index].name
  network_id         = var.ports[count.index].network_id
  admin_state_up     = var.ports[count.index].admin_state_up
  security_group_ids = var.ports[count.index].no_security_groups ? null : var.ports[count.index].security_group_ids
  no_security_groups = var.ports[count.index].no_security_groups
  description        = var.ports[count.index].description
  dns_name           = var.ports[count.index].dns_name
  qos_policy_id      = var.ports[count.index].qos_policy_id
  mac_address        = var.ports[count.index].mac_address
  no_fixed_ip        = var.ports[count.index].no_fixed_ip
  value_specs        = var.ports[count.index].value_specs

  dynamic "fixed_ip" {
    for_each = var.ports[count.index].fixed_ips
    content {
      subnet_id  = fixed_ip.value.subnet_id
      ip_address = fixed_ip.value.ip_address
    }
  }

  # Fallback to variable subnet_id if fixed_ips is empty
  dynamic "fixed_ip" {
    for_each = length(var.ports[count.index].fixed_ips) == 0 && var.ports[count.index].subnet_id != null ? [1] : []
    content {
      subnet_id = var.ports[count.index].subnet_id
    }
  }

  dynamic "allowed_address_pairs" {
    for_each = var.ports[count.index].allowed_address_pairs
    content {
      ip_address  = allowed_address_pairs.value.ip_address
      mac_address = allowed_address_pairs.value.mac_address
    }
  }

  dynamic "extra_dhcp_option" {
    for_each = var.ports[count.index].extra_dhcp_options
    content {
      name       = extra_dhcp_option.value.name
      value      = extra_dhcp_option.value.value
      ip_version = lookup(extra_dhcp_option.value, "ip_version", 4)
    }
  }

  dynamic "binding" {
    for_each = var.ports[count.index].binding != null ? [var.ports[count.index].binding] : []
    content {
      host_id   = binding.value.host_id
      vnic_type = binding.value.vnic_type
      profile   = binding.value.profile
    }
  }

  port_security_enabled = var.ports[count.index].port_security
  tags                  = var.ports[count.index].tags
}

# Create hot ports (attached after creation time)
resource "openstack_networking_port_v2" "hot_ports" {
  count = length(var.hot_ports)

  name               = var.hot_ports[count.index].name
  network_id         = var.hot_ports[count.index].network_id
  admin_state_up     = var.hot_ports[count.index].admin_state_up
  security_group_ids = var.hot_ports[count.index].no_security_groups ? null : var.hot_ports[count.index].security_group_ids
  no_security_groups = var.hot_ports[count.index].no_security_groups
  description        = var.hot_ports[count.index].description
  dns_name           = var.hot_ports[count.index].dns_name
  qos_policy_id      = var.hot_ports[count.index].qos_policy_id
  mac_address        = var.hot_ports[count.index].mac_address
  no_fixed_ip        = var.hot_ports[count.index].no_fixed_ip
  value_specs        = var.hot_ports[count.index].value_specs

  dynamic "fixed_ip" {
    for_each = var.hot_ports[count.index].fixed_ips
    content {
      subnet_id  = fixed_ip.value.subnet_id
      ip_address = fixed_ip.value.ip_address
    }
  }

  dynamic "fixed_ip" {
    for_each = length(var.hot_ports[count.index].fixed_ips) == 0 && var.hot_ports[count.index].subnet_id != null ? [1] : []
    content {
      subnet_id = var.hot_ports[count.index].subnet_id
    }
  }

  dynamic "allowed_address_pairs" {
    for_each = var.hot_ports[count.index].allowed_address_pairs
    content {
      ip_address  = allowed_address_pairs.value.ip_address
      mac_address = allowed_address_pairs.value.mac_address
    }
  }

  dynamic "extra_dhcp_option" {
    for_each = var.hot_ports[count.index].extra_dhcp_options
    content {
      name       = extra_dhcp_option.value.name
      value      = extra_dhcp_option.value.value
      ip_version = lookup(extra_dhcp_option.value, "ip_version", 4)
    }
  }

  dynamic "binding" {
    for_each = var.hot_ports[count.index].binding != null ? [var.hot_ports[count.index].binding] : []
    content {
      host_id   = binding.value.host_id
      vnic_type = binding.value.vnic_type
      profile   = binding.value.profile
    }
  }

  port_security_enabled = var.hot_ports[count.index].port_security
  tags                  = var.hot_ports[count.index].tags
}

# Create instance
resource "openstack_compute_instance_v2" "instance" {
  name         = var.name
  flavor_name  = var.flavor_name
  flavor_id    = var.flavor_id
  image_id     = var.image_id
  image_name   = var.image_name
  network_mode = var.network_mode

  block_device {
    uuid                  = openstack_blockstorage_volume_v3.volume_os.id
    source_type           = "volume"
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = var.block_device_delete_on_termination
    guest_format          = var.block_device_guest_format
    device_type           = var.block_device_device_type
    disk_bus              = var.block_device_disk_bus
  }

  key_pair = var.key_pair_name

  config_drive = var.config_drive
  admin_pass   = var.admin_pass
  user_data    = var.user_data

  # Attach boot ports to the instance at boot time
  dynamic "network" {
    for_each = openstack_networking_port_v2.boot_ports
    content {
      port = network.value.id
    }
  }

  # Metadata block
  metadata = { for key, value in var.metadata : key => value if value != null }

  # Scheduler hints
  dynamic "scheduler_hints" {
    for_each = var.scheduler_hints != null ? [var.scheduler_hints] : []
    content {
      group                 = lookup(scheduler_hints.value, "group", null)
      different_host        = lookup(scheduler_hints.value, "different_host", null)
      same_host             = lookup(scheduler_hints.value, "same_host", null)
      query                 = lookup(scheduler_hints.value, "query", null)
      target_cell           = lookup(scheduler_hints.value, "target_cell", null)
      build_near_host_ip    = lookup(scheduler_hints.value, "build_near_host_ip", null)
      additional_properties = lookup(scheduler_hints.value, "additional_properties", null)
    }
  }

  # Availability zone
  availability_zone       = var.instance_availability_zone
  availability_zone_hints = var.instance_availability_zone_hints
  hypervisor_hostname     = var.hypervisor_hostname

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

# Attach hot ports after instance creation
resource "openstack_compute_interface_attach_v2" "hot_ports_attach" {
  count       = length(openstack_networking_port_v2.hot_ports)
  instance_id = openstack_compute_instance_v2.instance.id
  port_id     = openstack_networking_port_v2.hot_ports[count.index].id
}

# Attach extra volumes
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

# Attach floating IP
resource "openstack_networking_floatingip_associate_v2" "ipa" {
  count       = var.public_ip_network == null ? 0 : 1
  floating_ip = openstack_networking_floatingip_v2.ip[count.index].address
  port_id = var.floating_ip_port_index < length(openstack_networking_port_v2.boot_ports) ? (
    openstack_networking_port_v2.boot_ports[var.floating_ip_port_index].id
    ) : (
    length(openstack_networking_port_v2.hot_ports) > 0 ? openstack_networking_port_v2.hot_ports[var.floating_ip_port_index - length(openstack_networking_port_v2.boot_ports)].id : null
  )
}