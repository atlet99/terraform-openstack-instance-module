output "network_id" {
  value       = module.network.network_id
  description = "Network ID created by network module."
}

output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "Security group ID created by security-group module."
}

output "instance_id" {
  value       = module.instance.instance_id
  description = "Instance ID created by instance module."
}

output "extra_volume_id" {
  value       = module.extra_volume.volume_id
  description = "Extra data volume ID attached to the instance."
}
