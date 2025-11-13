variable "node-name" {
  type = string
}

variable "base_image_raw_id" {
  type        = number
  description = "The VM ID of the base template to clone from"
}
