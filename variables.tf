variable "project_root" {
  type        = string
  description = "Absolute path to the aether-vault directory"
  # Users change this locally, but we leave the default empty or generic
}

variable "user_mapping" {
  type    = string
  default = "1000:1000"
}
