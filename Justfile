# Default command to deploy the infrastructure and configure it
apply:
	@echo "1/3 Applying Terraform configuration..."
	# This initializes Terraform and provisions the GCP server and firewall rules
	cd terraform && terraform init && terraform apply -auto-approve
	
	@echo "2/3 Updating Ansible inventory..."
	# This grabs the new public IP address from Terraform and writes it to Ansible's inventory file
	echo "[app_servers]" > ansible/inventory.ini
	echo "$$(cd terraform && terraform output -raw instance_ip) ansible_user=$$(cd terraform && terraform output -raw ssh_user) ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ansible/inventory.ini
	
	@echo "3/3 Running Ansible playbook..."
	# This installs any required Ansible collections and runs the playbook to configure the server
	cd ansible && ansible-galaxy collection install community.docker
	cd ansible && ansible-playbook playbook.yml

# Command to delete all the resources created by Terraform
destroy:
	@echo "Destroying infrastructure..."
	cd terraform && terraform destroy -auto-approve

# Command to preview what Terraform will do without actually applying it
plan:
	cd terraform && terraform init && terraform plan
