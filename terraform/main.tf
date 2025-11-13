

module "ephemeral" {
  source = "./modules/ephemeral"
  node-name = var.node-name
  base_vm_id  = module.base_image.base_image_raw_id
}

module "dev" {
  source = "./modules/dev"
  node-name = var.node-name
  base_vm_id = module.persistent.base_template_vm_id
  base_raw_vm_id = module.persistent.base_template_raw_vm_id
}

module "persistent" {
  source = "./modules/persistent"
  node-name = var.node-name
}

module "base_image" {
  source = "./modules/base_image"
  base_image_raw_id = 301
  node-name = var.node-name
}