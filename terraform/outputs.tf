output "instance_ip" {
  description = "The public IP of the application server"
  value       = google_compute_instance.app_server.network_interface[0].access_config[0].nat_ip
}

output "ssh_user" {
  value = var.ssh_user
}
