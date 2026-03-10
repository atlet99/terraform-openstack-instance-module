# Terraform Openstack Instances

_This project aims to create a module to deploy instance(s) on openstack provider._

![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/atlet99/openstack-tf-instance-module)

**Note:** This module requires **Terraform version 1.5.0** or higher and **OpenStack provider version 3.0.0** or higher.

## Terraform Registry

```hcl
module "instance-module" {
  source  = "atlet99/instance-module/openstack"
  version = "1.0.2"
  # insert the 4 required variables here
}
```

## Usage examples

```terraform
module "test_instance_simple" {
	source  = "atlet99/instance-module/openstack"
	version = "1.0.2"
 
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= v1.5.0 |
| <a name="requirement_openstack"></a> [openstack](#requirement\_openstack) | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_openstack"></a> [openstack](#provider\_openstack) | 3.0.0 |

## Resources

| Name | Type |
|------|------|
| [openstack_blockstorage_volume_v3.volume_os](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/blockstorage_volume_v3) | resource |
| [openstack_compute_instance_v2.instance](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_instance_v2) | resource |
| [openstack_compute_interface_attach_v2.attached_ports](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_interface_attach_v2) | resource |
| [openstack_networking_floatingip_associate_v2.ipa](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_associate_v2) | resource |
| [openstack_networking_floatingip_v2.ip](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_floatingip_v2) | resource |
| [openstack_networking_port_v2.additional_ports](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |
| [openstack_networking_port_v2.main_port](https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/networking_port_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | AZ where volume's available. | `string` | `""` | no |
| <a name="input_block_device_delete_on_termination"></a> [block\_device\_delete\_on\_termination](#input\_block\_device\_delete\_on\_termination) | Delete block device when instance is shut down | `bool` | `true` | no |
| <a name="input_block_device_volume_size"></a> [block\_device\_volume\_size](#input\_block\_device\_volume\_size) | The volume size of block device | `number` | `20` | no |
| <a name="input_flavor_name"></a> [flavor\_name](#input\_flavor\_name) | Instance's flavor name referenced in openstack | `string` | n/a | yes |
| <a name="input_image_id"></a> [image\_id](#input\_image\_id) | The image's id referenced in openstack | `string` | n/a | yes |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | The name of the ssh key referenced in openstack | `string` | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | Metadata for the OpenStack instance, used for categorization and identification of the service across environments and projects:<br/>- environment: Specifies the deployment environment (e.g., "dev", "staging", "prod", "infra") to indicate where the instance is used.<br/>- project: Defines the project name or identifier associated with this instance (e.g., "tesla"), useful for organizing and filtering resources within larger environments.<br/>- service\_type: Describes the type of service provided by this instance (e.g., "runner", "database", "web"), helping to classify the role of the instance in the architecture.<br/>- service\_name: A unique name for the specific service this instance runs (e.g., "tesla\_runner\_infra"), enabling more granular tracking and management of resources.<br/>- service\_role: Defines the role of the instance within the service (e.g., "master", "worker", "backup"), useful for distributed or clustered services with distinct roles.<br/>These metadata fields allow for more effective resource organization, monitoring, and automated management within OpenStack and other third-party integrations. | `map(string)` | <pre>{<br/>  "environment": null,<br/>  "project": null,<br/>  "service_name": null,<br/>  "service_role": null,<br/>  "service_type": null<br/>}</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | Instance's name | `string` | n/a | yes |
| <a name="input_ports"></a> [ports](#input\_ports) | The ports list, at least 1 port is required | <pre>list(object({<br/>    name               = string<br/>    network_id         = string<br/>    subnet_id          = string<br/>    admin_state_up     = optional(bool)<br/>    security_group_ids = optional(list(string))<br/>    ip_address         = optional(string)<br/>    port_security      = optional(bool)<br/>    allowed_address_pairs = optional(list(object({<br/>      ip_address  = string<br/>      mac_address = optional(string)<br/>    })), [])<br/>    tags = optional(list(string))<br/>  }))</pre> | <pre>[<br/>  {<br/>    "admin_state_up": true,<br/>    "allowed_address_pairs": [],<br/>    "ip_address": null,<br/>    "name": "",<br/>    "network_id": "",<br/>    "port_security": true,<br/>    "security_group_ids": [],<br/>    "subnet_id": "",<br/>    "tags": []<br/>  }<br/>]</pre> | no |
| <a name="input_public_ip_network"></a> [public\_ip\_network](#input\_public\_ip\_network) | The name of the network who give floating IPs | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | Region where volume's located. | `string` | `""` | no |
| <a name="input_server_groups"></a> [server\_groups](#input\_server\_groups) | List of server group id | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The instances tags | `list(string)` | `null` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data for instance | `string` | `null` | no |
| <a name="input_volume_type"></a> [volume\_type](#input\_volume\_type) | The type of volume to use, e.g., 'ceph-ssd', 'kz-ala-1-san-nvme-h1' or 'ceph-hdd' | `string` | `"ceph-ssd"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_additional_ports"></a> [additional\_ports](#output\_additional\_ports) | Details of additional ports attached to the instance. |
| <a name="output_attached_floating_ips"></a> [attached\_floating\_ips](#output\_attached\_floating\_ips) | List of floating IPs attached to additional ports. |
| <a name="output_floating_ips"></a> [floating\_ips](#output\_floating\_ips) | Flat list of floating IP addresses, if any. |
| <a name="output_instance_ids"></a> [instance\_ids](#output\_instance\_ids) | Flat list of instance IDs. |
| <a name="output_instance_info"></a> [instance\_info](#output\_instance\_info) | Flat list of ports with tags, names, private IPs, and MAC addresses for the instance. |
| <a name="output_primary_port"></a> [primary\_port](#output\_primary\_port) | Details of the primary port attached to the instance. |
| <a name="output_private_ips"></a> [private\_ips](#output\_private\_ips) | Flat list of private IP addresses for all ports (main and additional). |
<!-- END_TF_DOCS -->