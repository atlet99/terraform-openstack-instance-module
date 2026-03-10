output "instance_ids" {
  value       = module.complete_instance.instance_ids
  description = "Flat list of instance IDs."
}

output "private_ips" {
  value       = module.complete_instance.private_ips
  description = "Flat list of private IP addresses."
}

output "floating_ips" {
  value       = module.complete_instance.floating_ips
  description = "List of floating IP addresses."
}

output "instance_info" {
  value       = module.complete_instance.instance_info
  description = "Details about instance ports and IPs."
}

output "root_volume_id" {
  value       = module.complete_instance.root_volume_id
  description = "The ID of the instance boot volume."
}

output "instance_metadata" {
  value       = module.complete_instance.instance_metadata
  description = "The final metadata of the instance."
}
