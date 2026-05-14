output "instance_id" {
  value = module.instance_metadata_drift.instance_id
}

output "instance_metadata" {
  value = module.instance_metadata_drift.instance_metadata
}

output "root_volume_metadata" {
  value = module.instance_metadata_drift.root_volume_metadata
}
