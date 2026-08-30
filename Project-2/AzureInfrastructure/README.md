# Azure Infrastructure Setup with Terraform

This guide explains the Terraform-based steps to create the Azure infrastructure after cloning the repository.

## 1. Prerequisites

Before you begin, ensure the following are installed and available:

- Terraform
- Azure CLI
- Git
- An active Azure subscription
- Permission to create resources in the subscription

Check installation:

```bash
terraform version
az version
az login
```

If you are not logged in, run:

```bash
az login
az account set --subscription "<your-subscription-id>"
```

---

## 2. Clone the repository

```bash
git clone <repository-url>
cd <repository-folder>
```

Go to the Terraform directory:

```bash
cd Project-2/AzureInfrastructure/Dev
```

---

## 3. Review the Terraform configuration

The Terraform files in this folder include:

- `main.tf` - main infrastructure definition
- `variables.tf` - variables used by the configuration
- `terraform.tfvars` - actual values for deployment
- provider configuration and module references

Open the `terraform.tfvars` file and verify the values such as:

- resource group name
- location
- VNet name
- subnet ranges
- VM names and sizes
- NAT gateway name
- application gateway name
- database server name and credentials

Update the values as needed for your environment.

---

## 4. Initialize Terraform

Run:

```bash
terraform init
```

This downloads the required providers and modules.

---

## 5. Validate the configuration

Check syntax and configuration validity:

```bash
terraform validate
```

If there are errors, fix them before continuing.

---

## 6. Review the execution plan

Create a plan before applying changes:

```bash
terraform plan
```

This will display the resources Terraform intends to create, update, or delete.

Review:

- resource group
- virtual network and subnets
- network interfaces
- public and private VMs
- NAT gateway
- application gateway
- database resources

---

## 7. Create the Azure infrastructure

Apply the Terraform configuration:

```bash
terraform apply
```

If you want to skip confirmation prompts:

```bash
terraform apply -auto-approve
```

Terraform will start creating the Azure resources.

---

## 8. Check the created resources in Azure

After deployment completes, verify in Azure Portal or using Azure CLI:

```bash
az resource list --resource-group rg-dev-environment -o table
```

You can also inspect the Terraform output values if they are defined in the configuration.

---

## 9. Useful Terraform commands

### Re-run after changes

```bash
terraform plan
terraform apply
```

### Refresh state

```bash
terraform refresh
```

### Destroy infrastructure

If you want to delete the environment:

```bash
terraform destroy
```

Or:

```bash
terraform destroy -auto-approve
```

---

## 10. Important notes

- Azure resource names must be globally unique.
- Always confirm the subscription and region before deployment.
- Review VM sizes and quotas to avoid quota-related failures.
- If a database name or server name already exists in Azure, update the value in `terraform.tfvars`.
- Keep sensitive values such as passwords in secure storage or environment variables when possible.

---

## 11. Azure architecture topology

```mermaid
flowchart LR
    User[Internet User] --> PublicIP[Public IP<br/>attached to Application Gateway]
    PublicIP --> AppGW[Application Gateway<br/>inside public-subnet-2<br/>within the VNet]

    subgraph AzureResourceGroup[Resource Group: rg-dev-environment]
        subgraph VNet[Virtual Network: MyphpApp<br/>10.0.0.0/16]
            subgraph PublicSubnet[Public Subnet<br/>10.0.2.0/24]
                AppGW
                PublicVM[public-web-vm<br/>Public IP<br/>SSH + HTTP]
            end

            subgraph PrivateSubnet1[Private Subnet 1<br/>10.0.3.0/24]
                PrivateVM[private-app-vm<br/>No Public IP<br/>SSH only]
                NAT[NAT Gateway<br/>attached to private-subnet-1]
            end

            subgraph PrivateSubnet2[Private Subnet 2<br/>10.0.4.0/24]
                AppBackend[Optional backend/app resources]
            end

            subgraph MySQLSubnet[MySQL Subnet<br/>10.0.5.0/24]
                MySQL[Azure Database for MySQL Flexible Server<br/>Private DNS + Private Link]
            end

            subgraph ACRSubnet[Container Registry<br/>Azure Container Registry]
                ACR[Azure Container Registry<br/>Private image repository]
            end
        end

        KeyVault[Azure Key Vault<br/>Secrets + RBAC access]
        RoleAssignment[RBAC Role Assignments<br/>VM identity to Key Vault and ACR]
    end

    AppGW -->|HTTP/HTTPS| PrivateVM
    PublicVM -->|SSH| PrivateVM
    PrivateVM -->|Private DNS + VNet routing| MySQL
    NAT -->|Outbound internet access| PrivateSubnet1

    PublicVM -->|Managed Identity + RBAC| ACR
    PrivateVM -->|Managed Identity + RBAC| ACR
    PublicVM -->|Managed Identity + RBAC| KeyVault
    PrivateVM -->|Managed Identity + RBAC| KeyVault
    RoleAssignment --> ACR
    RoleAssignment --> KeyVault
```

### Architecture summary

- Resource Group is the top-level Azure container for all resources.
- Virtual Network and subnets are created first to provide the private/public segmentation.
- Public VM is placed in the public subnet and has a public IP.
- Private VM is placed in a private subnet and does not have a public IP.
- Application Gateway sits in the public subnet and routes traffic to the private application VM.
- NAT Gateway is attached to the private subnet for outbound internet access.
- Azure Database for MySQL is created in a dedicated delegated subnet and accessed privately through VNet DNS.
- Azure Container Registry stores container images and is accessed through RBAC-managed identities.
- Azure Key Vault stores secrets, and both VMs receive RBAC permissions to fetch and list secret values.
- Role assignments connect the VM managed identities to the ACR and Key Vault so they can access resources securely without hardcoded credentials.

---

## 12. Beginner-friendly resource creation flow

Below is the order in which resources are typically created in this project so a beginner can understand the setup clearly.

### Step 1: Create the Resource Group

This is the logical container where all Azure infrastructure is stored.

- Resource group is created first.
- All later resources belong to this group.

### Step 2: Create the Virtual Network and subnets

The network is created next because the VMs, NAT gateway, App Gateway, and database need a network boundary.

Resources created:

- VNet
- Public subnet
- Private subnet
- MySQL delegated subnet

### Step 3: Create the Virtual Machines

The VMs are created inside the defined subnets.

Resources created:

- Public IP (for public VM)
- NSG rules for SSH/HTTP
- NICs
- Linux virtual machines
- Managed identities for each VM

### Step 4: Create the NAT Gateway

NAT Gateway is attached to the private subnet to allow outbound internet connectivity for private resources.

### Step 5: Create the Application Gateway

This is placed in the public subnet and routes traffic to the private VM.

Resources created:

- Public IP for the gateway
- Application Gateway
- Listener and routing configuration
- Backend pool pointing to the private VM

### Step 6: Create the Azure Database for MySQL

The database is deployed inside the MySQL subnet with private DNS support.

Resources created:

- MySQL subnet
- Private DNS zone
- VNet link
- MySQL Flexible Server
- Database instance

### Step 7: Create the Azure Container Registry

The registry is created to store Docker images for the application.

Resources created:

- Azure Container Registry

### Step 8: Create the Azure Key Vault

This stores secret values, certificates, and app configuration data.

Resources created:

- Azure Key Vault

### Step 9: Create RBAC role assignments

The VM managed identities are granted permissions to Key Vault and ACR.

Resources created:

- Role assignments for VM identities
- Permissions such as ACR access and Key Vault access

This makes the VMs able to:

- pull container images from ACR
- push images to ACR
- fetch secrets from Key Vault
- list secrets from Key Vault

---

## 13. Recommended deployment flow

Use this sequence for each deployment:

```bash
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

This is the standard flow to create the Azure infrastructure from the repository.
