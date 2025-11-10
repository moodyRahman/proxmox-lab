
variable "node-name" {
  type = string
}

variable "base_vm_id" {
  type        = number
  description = "The VM ID of the base template to clone from"
}

variable "base_raw_vm_id" {
  type        = number
  description = "The VM ID of the base template to clone from"
}
