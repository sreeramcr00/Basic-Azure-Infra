# Azure Setup & Terraform Deployment Guide
## 1. Set up Azure Service Principal
To authenticate Terraform with Azure, set the following environment variables using your Azure Service Principal credentials.

🪟 On Windows (PowerShell):
```
$env:ARM_CLIENT_ID="your-client-id"
$env:ARM_CLIENT_SECRET="your-client-secret"
$env:ARM_TENANT_ID="your-tenant-id"
$env:ARM_SUBSCRIPTION_ID="your-subscription-id"
```
🐧 On Linux/macOS (bash):
```
export ARM_CLIENT_ID="your-client-id"
export ARM_CLIENT_SECRET="your-client-secret"
export ARM_TENANT_ID="your-tenant-id"
export ARM_SUBSCRIPTION_ID="your-subscription-id"
```
🔐 Tip: Never hardcode credentials in .tf files. Use environment variables to keep things secure.

## 2. Generate SSH Key in Azure (Required for VM Access)
 Using Azure CLI
 ```
az sshkey create \
  --name mySSHKey \
  --resource-group myResourceGroup \
  --location eastus
```
This command creates an SSH key and stores it in Azure.
You can reference this key when creating a virtual machine in Terraform using its name.

## 3. Terraform Workflow
Once your environment variables and SSH keys are ready, follow the Terraform flow:

Step-by-Step:
Initialize Terraform:
```
terraform init
```
Validate Configuration (Optional but recommended):

```
terraform validate
```
Preview the Infrastructure Changes:

```
terraform plan
```
Apply the Configuration (Create Resources):

```
terraform apply
```
You will be prompted to approve changes before resources are created.

Destroy Resources (Optional, for cleanup):
```
terraform destroy
```

Example Directory Structure
```
project-root/
├── main.tf
├── variables.tf
├── terraform.tfvars
└── outputs.tf
```