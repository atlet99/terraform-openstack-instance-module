variable "external_network_id" {
  type        = string
  description = "External network ID for router and optional floating IP pool name."
}

variable "flavor_name" {
  type        = string
  description = "Flavor name for the instance."
}

variable "image_name" {
  type        = string
  description = "Image name used to create boot volume."
}

variable "key_pair_name" {
  type        = string
  description = "OpenStack key pair name for SSH access."
}
