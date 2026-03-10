module "simple_instance" {
  source = "../../"

  name          = "simple-vm"
  image_id      = var.image_id
  flavor_name   = var.flavor_name
  key_pair_name = var.key_pair_name

  ports = [
    {
      name       = "main-port"
      network_id = var.network_id
      subnet_id  = var.subnet_id
    }
  ]
}
