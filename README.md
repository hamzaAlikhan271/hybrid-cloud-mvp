# Hybrid Cloud MVP - Terraform Deployment

This repository contains the Terraform code for deploying a scalable and secure hybrid cloud architecture on AWS, including:

✅ 3 VPCs (Shared, Production, DR)  
✅ Transit Gateway + Attachments  
✅ VPN to on-prem (strongSwan)  
✅ Auto-scaling, backups, security controls  

---

## Structure
├── main.tf
├── vpn.tf
├── outputs.tf
├── variables.tf
├── provider.tf
└── README.md

---

## Deployment

```sh
terraform init
terraform plan
terraform apply

