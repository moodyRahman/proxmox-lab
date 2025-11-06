

module "ephemeral" {
  source = "./modules/ephemeral"
  node-name = var.node-name
  base_vm_id  = module.persistent.base_template_vm_id
}

module "persistent" {
  source = "./modules/persistent"
  node-name = var.node-name

}

