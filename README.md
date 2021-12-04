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
