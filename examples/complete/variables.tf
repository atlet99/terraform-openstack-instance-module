variable "image_id" {
  type        = string
  description = "The image's id referenced in openstack"
}

variable "flavor_name" {
  type        = string
  description = "Instance's flavor name referenced in openstack"
}

variable "key_pair_name" {
  type        = string
  description = "The name of the ssh key referenced in openstack"
}

variable "network_id" {
  type        = string
  description = "The network ID"
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID"
}

variable "public_ip_network" {
  type        = string
  description = "The name of the network who give floating IPs"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
  default     = []
}
