# Terraform

This is a Terraform proof of concept on how to provision infrastructure to azure cloud.

## Summary

This repo is conform by three folders:

1. IaC (Infrastructure as code): where all the terraform code is in.
2. todoservice an express js example backend application to test our infraestructure
3. todoui an angular frontend application to test our infrastructure.

Our terraform code provisions a resource group with:

- Two app services configured to be deployed as containers, picking the image from dockerhub. I'm are also creating a custom domain for the frontend app using an already existing DNS Zone outside the resource group.
- A vnet to hold all our resoureces as private.
- An App Gateway as a main entrypoint to our network to access the app services.

- NOTE: DNS Zone provisioning was manual due to the need of getting the DNS server urls posterior to its creation to be registered into the admin's portal of the domain's provider.

## Getting Started

### Prerequisites

1. Download and install terraform CLI and AZ cli.
2. You will also need a DNS zone in that subscription.
3. You will need a storage account with a container for the tfstate file.

### Provisioning infrastructure as code

1. Run `az login` to login into an azure subscription. A browser will be opened for you to login.
2. Rename example.tfvars to terraform.tfvars and replace exmaple values with the ones you want to use.
3. Rename backend.example.tfvars to backend.tfvars and replace exmaple values with the storage account container and resource group of the prerequisites.
4. cd into ./IaC folder.
5. run `terraform init -backend-config=./backend.tfvars`.
6. run `terraform apply` and confirm with `yes`.
7. To tear down all the resources created with terraform run `terraform destroy` and confirm with `yes`.
