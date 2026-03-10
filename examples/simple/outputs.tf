output "instance_ids" {
  value       = module.simple_instance.instance_ids
  description = "Flat list of instance IDs."
}

output "private_ips" {
  value       = module.simple_instance.private_ips
  description = "Flat list of private IP addresses."
}
