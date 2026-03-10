module "complete_instance" {
  source = "../../"

  name          = "complete-vm"
  image_id      = var.image_id
  flavor_name   = var.flavor_name
  key_pair_name = var.key_pair_name

  user_data = "#cloud-config\nhostname: complete-vm"

  public_ip_network = var.public_ip_network

  metadata = {
    environment  = "dev"
    project      = "demo"
    service_type = "web"
  }

  instance_availability_zone = "nova"
  vendor_options = {
    ignore_resize_confirmation = true
  }

  personalities = [
    {
      file    = "/etc/motd"
      content = "Welcome to the complete example VM!"
    }
  ]

  power_state         = "active"
  force_delete        = true
  stop_before_destroy = true

  tags = ["web", "nginx", "complete-example"]

  ports = [
    {
      name               = "primary-port"
      network_id         = var.network_id
      subnet_id          = var.subnet_id
      admin_state_up     = true
      security_group_ids = var.security_group_ids
      description        = "Primary application port"
    },
    {
      name               = "admin-port"
      network_id         = var.network_id
      subnet_id          = var.subnet_id
      no_security_groups = true
      description        = "Administration port without security groups"
      dns_name           = "admin-vm"
    }
  ]

  floating_ip_port_index = 0 # Attach FIP to primary-port

  block_device_volume_size           = 40
  block_device_delete_on_termination = true
  volume_type                        = "ceph-ssd"
  block_device_description           = "Root volume for complete example"

  fip_description = "Public access IP"
}
