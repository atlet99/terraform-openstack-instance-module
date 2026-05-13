module "network" {
  source  = "atlet99/network-module/openstack"
  version = "1.0.6"

  name = "integration-net"
  router = {
    create              = true
    external_network_id = var.external_network_id
  }

  subnets = [
    {
      cidr      = "10.42.0.0/24"
      router_id = "@self"
    }
  ]
}

module "security_group" {
  source  = "atlet99/security-group-module/openstack"
  version = "1.0.1"

  name = "integration-sg"
  ingress_rules = [
    {
      protocol         = "tcp"
      port             = 22
      remote_ip_prefix = "0.0.0.0/0"
      description      = "Allow SSH"
    }
  ]
  egress_rules = [
    {
      protocol         = "tcp"
      remote_ip_prefix = "0.0.0.0/0"
      description      = "Allow all TCP egress"
    }
  ]
}

module "instance" {
  source = "../../"

  name          = "integration-vm"
  flavor_name   = var.flavor_name
  image_name    = var.image_name
  key_pair_name = var.key_pair_name

  ports = [
    {
      name               = "integration-primary"
      network_id         = module.network.network_id
      security_group_ids = [module.security_group.security_group_id]
      fixed_ips = [
        {
          subnet_id = module.network.subnets[0].id
        }
      ]
    }
  ]

  public_ip_network      = var.external_network_id
  floating_ip_port_index = 0
}

module "extra_volume" {
  source  = "atlet99/volume-module/openstack"
  version = "1.0.3"

  name        = "integration-data"
  size        = 5
  volume_type = "ceph-ssd"
  instance_id = module.instance.instance_ids[0]
}
