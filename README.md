# Infrastructure Setup (K3s)

This directory contains the Infrastructure as Code (Terraform) and Configuration as Code (Ansible) required to provision and configure a single-node Kubernetes (K3s) cluster on Google Cloud Platform.

## Prerequisites

Before running the deployment, you must have the following tools installed on your local machine:

### 1. Homebrew (macOS)
If you don't have Homebrew installed, run:
```bash
/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### 2. Required Tools
You can install all the required tools using Homebrew:

```bash
# Install Terraform (Infrastructure Provisioning)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Install Ansible (Configuration Management)
brew install ansible

# Install Just (Command Runner)
brew install just

# Install JQ (JSON Parser required by the Justfile)
brew install jq

# Install Google Cloud SDK (For Authentication)
brew install --cask google-cloud-sdk
```

## Authentication

Before running the deployment, you must authenticate with Google Cloud:
```bash
gcloud auth application-default login
```

## Configuration

1. Open `terraform/variables.tf`
2. Update the `project_id` variable with your actual Google Cloud Project ID.

## Deployment

To create the server and fully deploy the Kubernetes cluster, run:
```bash
just apply
```

To run a temporary test deployment and automatically tear it down when finished, run:
```bash
just test-ephemeral
```

To manually destroy all created resources and stop billing, run:
```bash
just destroy
```
