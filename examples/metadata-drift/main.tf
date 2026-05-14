module "instance_metadata_drift" {
  source = "../../"

  name          = "metadata-drift-vm"
  image_id      = var.image_id
  flavor_name   = var.flavor_name
  key_pair_name = var.key_pair_name

  metadata = {
    environment = "dev"
    owner       = "platform-team"
  }

  block_device_metadata = {
    managed_by = "terraform"
    workload   = "instance"
  }

  # Leave this true to avoid plan/apply drift when platform or provider
  # injects additional system metadata keys on the boot volume.
  ignore_boot_volume_metadata_changes = true

  ports = [
    {
      name       = "main-port"
      network_id = var.network_id
      subnet_id  = var.subnet_id
    }
  ]
}
