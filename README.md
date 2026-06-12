# Infrastructure Setup (K3s)

This directory contains the Infrastructure as Code (Terraform) and Configuration as Code (Ansible) required to provision and configure a single-node Kubernetes (K3s) cluster on Google Cloud Platform.

## Prerequisites

Before running the deployment, ensure the following tools are installed on your local machine:

* Terraform
* Ansible
* Just
* JQ
* Google Cloud SDK (gcloud)
* SSH client

---

# macOS Setup

## 1. Install Homebrew

If Homebrew is not already installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## 2. Install Required Tools

```bash
# Install Terraform
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install Ansible
brew install ansible

# Install Just
brew install just

# Install JQ
brew install jq

# Install Google Cloud SDK
brew install --cask google-cloud-sdk
```

## 3. Verify Installation

```bash
terraform version
ansible --version
just --version
jq --version
gcloud version
```

---

# Ubuntu / Debian Setup

## 1. Update System Packages

```bash
sudo apt update && sudo apt upgrade -y
```

## 2. Install Terraform

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update
sudo apt install terraform -y
```

Verify:

```bash
terraform version
```

## 3. Install Ansible

```bash
sudo apt install ansible -y
```

Verify:

```bash
ansible --version
```

## 4. Install Just

```bash
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ~/bin

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verify:

```bash
just --version
```

## 5. Install JQ

```bash
sudo apt install jq -y
```

Verify:

```bash
jq --version
```

## 6. Install Google Cloud SDK

```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
```

Verify:

```bash
gcloud version
```

## 7. Verify Installation

```bash
terraform version
ansible --version
just --version
jq --version
gcloud version
```

---

# Windows Setup

> Recommended: Use WSL (Windows Subsystem for Linux) and follow the Ubuntu setup instructions above.

## 1. Install WSL

Open PowerShell as Administrator:

```powershell
wsl --install
```

Restart your computer if prompted.

Verify:

```powershell
wsl --status
```

## 2. Open Ubuntu

After installation, launch **Ubuntu** from the Start Menu.

Verify that Ubuntu is running:

```bash
lsb_release -a
```

## 3. Follow Ubuntu Setup

Once Ubuntu is installed, complete all steps in the **Ubuntu / Debian Setup** section above.

All project commands should be executed from the Ubuntu terminal rather than PowerShell.

---

# Google Cloud Authentication

Before running the deployment, authenticate with Google Cloud:

```bash
gcloud auth application-default login
```

Verify the authenticated account:

```bash
gcloud auth list
```

Verify the active project:

```bash
gcloud config list
```

---

# Configuration

## 1. Configure Project ID

Open:

```text
terraform/variables.tf
```

Update the `project_id` variable:

```hcl
variable "project_id" {
  default = "your-gcp-project-id"
}
```

Replace `your-gcp-project-id` with your actual Google Cloud Project ID.

---

# Deployment

## Create Infrastructure and Deploy K3s

```bash
just apply
```

This command:

1. Provisions infrastructure using Terraform.
2. Configures the server using Ansible.
3. Installs and configures K3s.
4. Prepares the Kubernetes cluster for workloads.

---

## Run Temporary Ephemeral Environment

Creates infrastructure, runs validation/testing, and automatically destroys resources when complete:

```bash
just test-ephemeral
```

Useful for CI/CD validation and development testing.

---

## Destroy Infrastructure

Remove all provisioned resources and stop Google Cloud billing:

```bash
just destroy
```

Always destroy unused environments to avoid unnecessary charges.

---

# Verification

After deployment, verify the cluster is healthy.

## Check Node Status

```bash
kubectl get nodes
```

Expected output:

```text
NAME         STATUS   ROLES                  AGE
k3s-server   Ready    control-plane,master   ...
```

## Check System Pods

```bash
kubectl get pods -A
```

All system pods should be in a `Running` state.

---

# Troubleshooting

## Terraform Authentication Errors

Re-authenticate with Google Cloud:

```bash
gcloud auth application-default login
```

Verify credentials:

```bash
gcloud auth list
```

---

## Ansible Connection Errors

Verify SSH access to the provisioned server:

```bash
ssh <user>@<server-ip>
```

Test Ansible connectivity:

```bash
ansible all -m ping
```

---

## Google Cloud API Errors

Ensure the required APIs are enabled:

* Compute Engine API
* Cloud Resource Manager API
* IAM API

Enable them with:

```bash
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable iam.googleapis.com
```

Verify enabled services:

```bash
gcloud services list --enabled
```

---

## Verify Terraform State

```bash
terraform state list
```

---

## Verify Kubernetes Access

```bash
kubectl cluster-info
kubectl get nodes
kubectl get pods -A
```

If these commands succeed, the K3s cluster has been deployed successfully.
