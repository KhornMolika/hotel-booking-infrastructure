# Default command to deploy the K3s HA cluster and configure it
apply:
	@echo "1/3 Applying Terraform configuration..."
	cd terraform && terraform init && terraform apply -auto-approve
	
	@echo "2/3 Updating Ansible inventory for K3s..."
	@bash -c '\
		echo "[master_1]" > ansible/inventory.ini; \
		IP=$(cd terraform && terraform output -raw instance_ip); \
		USER=$(cd terraform && terraform output -raw ssh_user); \
		echo "$IP ansible_user=$USER ansible_ssh_common_args=\"-o StrictHostKeyChecking=no\"" >> ansible/inventory.ini; \
	'
	
	@echo "3/3 Running Ansible playbook to install K3s and deploy apps..."
	cd ansible && ansible-playbook playbook.yml

destroy:
	@echo "Destroying infrastructure..."
	cd terraform && terraform destroy -auto-approve

plan:
	cd terraform && terraform init && terraform plan

test-ephemeral:
	@echo "Starting Ephemeral Deployment Test..."
	just apply
	@echo "\n==============================================================="
	@echo "K3S CLUSTER DEPLOYMENT COMPLETE! The servers are now running."
	@echo "Press [ENTER] when you are finished testing to destroy the cluster."
	@echo "===============================================================\n"
	@bash -c 'read -s -n 1 -p ""'
	just destroy
