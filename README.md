# Terraform Openstack Instances

_This project aims to create a module to deploy instance(s) on openstack provider._

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/atlet99/openstack-tf-instance-module)

**Note:** This module requires **Terraform version 1.5.0** or higher and **OpenStack provider version 3.2.0** or higher.

## Terraform Registry

```hcl
module "instance-module" {
  source  = "atlet99/instance-module/openstack"
  version = "1.0.3"
  # insert the 4 required variables here
}
```

## Usage examples

```terraform
module "test_instance_simple" {
	source  = "atlet99/instance-module/openstack"
	version = "1.0.3"
 
	name = "instance"
	flavor_name = "m1.xs" 
	image_id = "<image_id>"
	key_pair_name = "my_key_pair"
	public_ip_network = "floating"

	ports = [
		{
			name = "db_port",
			network_id = "db_network_id",
			subnet_id = "db_subnet_id",
		},
		{
			name = "web_port",
			network_id = "web_network_id",
			subnet_id = "web_subnet_id",
		}
	]
	server_groups = ["web"]
}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 3.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 3.2.0 |

## Resources

| Name | Type |
|------|------|
| [openstack_blockstorage_volume_v3.volume_os](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/blockstorage_volume_v3) | resource |
| [openstack_compute_instance_v2.instance](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_compute_interface_attach_v2.hot_ports_attach](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_interface_attach_v2) | resource |
| [openstack_compute_volume_attach_v2.extra_volumes](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_volume_attach_v2) | resource |
| [openstack_networking_floatingip_associate_v2.ipa](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_associate_v2) | resource |
| [openstack_networking_floatingip_v2.ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_v2) | resource |
| [openstack_networking_port_v2.boot_ports](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.hot_ports](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_pass"></a> [admin\_pass](#input\_admin\_pass) | The administrative password to assign to the server. | `string` | `null` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ where volume's available. | `string` | `null` | no |
| <a name="input_backup_id"></a> [backup\_id](#input\_backup\_id) | The backup ID from which to create the volume. | `string` | `null` | no |
| <a name="input_block_device_delete_on_termination"></a> [block\_device\_delete\_on\_termination](#input\_block\_device\_delete\_on\_termination) | Delete block device when instance is shut down | `bool` | `true` | no |
| <a name="input_block_device_description"></a> [block\_device\_description](#input\_block\_device\_description) | The description of the block device. | `string` | `null` | no |
| <a name="input_block_device_device_type"></a> [block\_device\_device\_type](#input\_block\_device\_device\_type) | The low-level device type that will be used (e.g., cdrom). | `string` | `null` | no |
| <a name="input_block_device_disk_bus"></a> [block\_device\_disk\_bus](#input\_block\_device\_disk\_bus) | The low-level disk bus that will be used (e.g., virtio, scsi). | `string` | `null` | no |
| <a name="input_block_device_guest_format"></a> [block\_device\_guest\_format](#input\_block\_device\_guest\_format) | Specifies the guest server disk file system format, such as ext4 or swap. | `string` | `null` | no |
| <a name="input_block_device_metadata"></a> [block\_device\_metadata](#input\_block\_device\_metadata) | Metadata key/value pairs to associate with the volume. | `map(string)` | `{}` | no |
| <a name="input_block_device_scheduler_hints"></a> [block\_device\_scheduler\_hints](#input\_block\_device\_scheduler\_hints) | Provide the Cinder scheduler with hints on where to instantiate a volume. | `any` | `null` | no |
| <a name="input_block_device_volume_size"></a> [block\_device\_volume\_size](#input\_block\_device\_volume\_size) | The volume size of block device | `number` | `20` | no |
| <a name="input_config_drive"></a> [config\_drive](#input\_config\_drive) | Whether to use the config\_drive feature to configure the instance. | `bool` | `true` | no |
| <a name="input_consistency_group_id"></a> [consistency\_group\_id](#input\_consistency\_group\_id) | The consistency group to place the volume in. | `string` | `null` | no |
| <a name="input_enable_online_resize"></a> [enable\_online\_resize](#input\_enable\_online\_resize) | When this option is set it allows extending attached volumes. | `bool` | `true` | no |
| <a name="input_extra_volumes"></a> [extra\_volumes](#input\_extra\_volumes) | A list of additional volumes to attach to the instance. | <pre>list(object({<br/>    volume_id = string<br/>    device    = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_fip_description"></a> [fip\_description](#input\_fip\_description) | Human-readable description for the floating IP. | `string` | `null` | no |
| <a name="input_fip_dns_domain"></a> [fip\_dns\_domain](#input\_fip\_dns\_domain) | The floating IP DNS domain. | `string` | `null` | no |
| <a name="input_fip_dns_name"></a> [fip\_dns\_name](#input\_fip\_dns\_name) | The floating IP DNS name. | `string` | `null` | no |
| <a name="input_flavor_id"></a> [flavor\_id](#input\_flavor\_id) | Instance's flavor id referenced in openstack | `string` | `null` | no |
| <a name="input_flavor_name"></a> [flavor\_name](#input\_flavor\_name) | Instance's flavor name referenced in openstack | `string` | `null` | no |
| <a name="input_floating_ip_port_index"></a> [floating\_ip\_port\_index](#input\_floating\_ip\_port\_index) | The index of the port to associate the floating IP with (0 for first boot-port, then hot-ports). | `number` | `0` | no |
| <a name="input_force_delete"></a> [force\_delete](#input\_force\_delete) | Whether to force the OpenStack instance to be forcefully deleted. | `bool` | `false` | no |
| <a name="input_hot_ports"></a> [hot\_ports](#input\_hot\_ports) | Ports attached after instance creation (hot-plug). Does not cause replacement. | <pre>list(object({<br/>    name               = string<br/>    network_id         = string<br/>    subnet_id          = optional(string)<br/>    admin_state_up     = optional(bool, true)<br/>    security_group_ids = optional(list(string), [])<br/>    fixed_ips = optional(list(object({<br/>      subnet_id  = optional(string)<br/>      ip_address = optional(string)<br/>    })), [])<br/>    port_security      = optional(bool, true)<br/>    no_security_groups = optional(bool, false)<br/>    description        = optional(string)<br/>    dns_name           = optional(string)<br/>    qos_policy_id      = optional(string)<br/>    mac_address        = optional(string)<br/>    no_fixed_ip        = optional(bool, false)<br/>    value_specs        = optional(map(string), {})<br/>    allowed_address_pairs = optional(list(object({<br/>      ip_address  = string<br/>      mac_address = optional(string)<br/>    })), [])<br/>    extra_dhcp_options = optional(list(object({<br/>      name       = string<br/>      value      = string<br/>      ip_version = optional(number, 4)<br/>    })), [])<br/>    binding = optional(object({<br/>      host_id   = optional(string)<br/>      vnic_type = optional(string)<br/>      profile   = optional(string)<br/>    }))<br/>    tags = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_hypervisor_hostname"></a> [hypervisor\_hostname](#input\_hypervisor\_hostname) | Specifies the exact hypervisor hostname on which to create the instance. | `string` | `null` | no |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image's id referenced in openstack | `string` | `null` | no |
| <a name="input_image_name"></a> [image\_name](#input\_image\_name) | The image's name referenced in openstack | `string` | `null` | no |
| <a name="input_instance_availability_zone"></a> [instance\_availability\_zone](#input\_instance\_availability\_zone) | The availability zone in which to create the server. | `string` | `null` | no |
| <a name="input_instance_availability_zone_hints"></a> [instance\_availability\_zone\_hints](#input\_instance\_availability\_zone\_hints) | The availability zone hints in which to create the server. | `string` | `null` | no |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | The name of the ssh key referenced in openstack | `string` | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Metadata for the OpenStack instance. | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Instance's name | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Special string for 'network' option: 'auto' or 'none'. Conflicts with 'ports'. | `string` | `null` | no |
| <a name="input_personalities"></a> [personalities](#input\_personalities) | A list of files to inject into the instance at boot time. | <pre>list(object({<br/>    file    = string<br/>    content = string<br/>  }))</pre> | `[]` | no |
| <a name="input_ports"></a> [ports](#input\_ports) | Ports attached at boot time (causes replacement on change). If empty, OpenStack will create a default port. | <pre>list(object({<br/>    name               = string<br/>    network_id         = string<br/>    subnet_id          = optional(string)<br/>    admin_state_up     = optional(bool, true)<br/>    security_group_ids = optional(list(string), [])<br/>    fixed_ips = optional(list(object({<br/>      subnet_id  = optional(string)<br/>      ip_address = optional(string)<br/>    })), [])<br/>    port_security      = optional(bool, true)<br/>    no_security_groups = optional(bool, false)<br/>    description        = optional(string)<br/>    dns_name           = optional(string)<br/>    qos_policy_id      = optional(string)<br/>    mac_address        = optional(string)<br/>    no_fixed_ip        = optional(bool, false)<br/>    value_specs        = optional(map(string), {})<br/>    allowed_address_pairs = optional(list(object({<br/>      ip_address  = string<br/>      mac_address = optional(string)<br/>    })), [])<br/>    extra_dhcp_options = optional(list(object({<br/>      name       = string<br/>      value      = string<br/>      ip_version = optional(number, 4)<br/>    })), [])<br/>    binding = optional(object({<br/>      host_id   = optional(string)<br/>      vnic_type = optional(string)<br/>      profile   = optional(string)<br/>    }))<br/>    tags = optional(list(string), [])<br/>  }))</pre> | `[]` | no |
| <a name="input_power_state"></a> [power\_state](#input\_power\_state) | The VM state. Only 'active', 'shutoff', 'paused' and 'shelved\_offloaded' are supported values. | `string` | `"active"` | no |
| <a name="input_public_ip_network"></a> [public\_ip\_network](#input\_public\_ip\_network) | The name of the network who give floating IPs | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where volume's located. | `string` | `null` | no |
| <a name="input_scheduler_hints"></a> [scheduler\_hints](#input\_scheduler\_hints) | Provide the Nova scheduler with hints on where to instantiate an instance. | `any` | `null` | no |
| <a name="input_snapshot_id"></a> [snapshot\_id](#input\_snapshot\_id) | The snapshot ID from which to create the volume. | `string` | `null` | no |
| <a name="input_source_replica"></a> [source\_replica](#input\_source\_replica) | The volume ID to replicate with. | `string` | `null` | no |
| <a name="input_source_vol_id"></a> [source\_vol\_id](#input\_source\_vol\_id) | The volume ID from which to create the volume. | `string` | `null` | no |
| <a name="input_stop_before_destroy"></a> [stop\_before\_destroy](#input\_stop\_before\_destroy) | Whether to try stop instance gracefully before destroying it. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The instances tags | `list(string)` | `[]` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data for instance | `string` | `null` | no |
| <a name="input_vendor_options"></a> [vendor\_options](#input\_vendor\_options) | Vendor-specific options for the instance. | <pre>object({<br/>    ignore_resize_confirmation  = optional(bool, false)<br/>    detach_ports_before_destroy = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_volume_retype_policy"></a> [volume\_retype\_policy](#input\_volume\_retype\_policy) | Migration policy when changing volume\_type. 'never' or 'on-demand'. | `string` | `null` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of volume to use, e.g., 'ceph-ssd', 'kz-ala-1-san-nvme-h1' or 'ceph-hdd' | `string` | `"ceph-ssd"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_ip_v4"></a> [access\_ip\_v4](#output\_access\_ip\_v4) | The first detected IPv4 address of the instance. |
| <a name="output_access_ip_v6"></a> [access\_ip\_v6](#output\_access\_ip\_v6) | The first detected IPv6 address of the instance. |
| <a name="output_admin_pass"></a> [admin\_pass](#output\_admin\_pass) | The administrative password assigned to the server. |
| <a name="output_all_fixed_ips"></a> [all\_fixed\_ips](#output\_all\_fixed\_ips) | Full list of all fixed IP addresses on all ports. |
| <a name="output_all_metadata"></a> [all\_metadata](#output\_all\_metadata) | All metadata key/value pairs associated with the instance. |
| <a name="output_all_tags"></a> [all\_tags](#output\_all\_tags) | All tags associated with the instance. |
| <a name="output_availability_info"></a> [availability\_info](#output\_availability\_info) | Availability zone and hints for the instance. |
| <a name="output_boot_ports"></a> [boot\_ports](#output\_boot\_ports) | Details of ports attached at boot time. |
| <a name="output_created_at"></a> [created\_at](#output\_created\_at) | The creation time of the instance. |
| <a name="output_extra_volume_ids"></a> [extra\_volume\_ids](#output\_extra\_volume\_ids) | List of IDs for additional volumes attached to the instance. |
| <a name="output_floating_ips"></a> [floating\_ips](#output\_floating\_ips) | Flat list of floating IP addresses. |
| <a name="output_hot_ports"></a> [hot\_ports](#output\_hot\_ports) | Details of ports attached after boot (hot-plug). |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | Flat list of instance IDs. |
| <a name="output_instance_info"></a> [instance\_info](#output\_instance\_info) | Detailed list of all ports (boot and hot) with tags, IPs, MAC addresses and binding info. |
| <a name="output_instance_metadata"></a> [instance\_metadata](#output\_instance\_metadata) | The metadata associated with the instance. |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Flat list of the first private IP address for all ports. |
| <a name="output_root_volume_id"></a> [root\_volume\_id](#output\_root\_volume\_id) | The ID of the instance boot volume. |
| <a name="output_updated_at"></a> [updated\_at](#output\_updated\_at) | The time when the instance was last updated. |
<!-- END_TF_DOCS -->