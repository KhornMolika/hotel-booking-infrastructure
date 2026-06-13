variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "fir-dboperations"
}

variable "region" {
  description = "The region to deploy to"
  type        = string
  default     = "asia-southeast1"
}

variable "zone" {
  description = "The zone to deploy to"
  type        = string
  default     = "asia-southeast1-a"
}

variable "machine_type" {
  description = "The machine type for the instance"
  type        = string
  default     = "e2-medium"
}

variable "ssh_user" {
  description = "SSH username for Ansible connection"
  type        = string
  default     = "devops"
}

variable "ssh_pub_key_path" {
  description = "Path to the public SSH key to be added to the instance"
  type        = string
  default     = "/mnt/c/Users/LEGION/.ssh/id_ed25519.pub"
}
