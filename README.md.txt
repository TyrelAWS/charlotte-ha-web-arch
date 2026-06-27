 # High-Availability, Multi-Tier Automated Web Architecture

![Project Architecture](charlotte-ha-web-arch-diagram.png)

A production-grade, self-healing AWS infrastructure deployment engineered entirely as code (IaC) using Terraform. This project demonstrates network isolation, secure traffic routing, and automated scaling principles used in enterprise cloud environments.

## 🏗️ Architectural Overview

The architecture implements a strict zero-trust security model across multiple Availability Zones:
* **Public Layer:** An Application Load Balancer (ALB) acting as the single internet-facing gateway, distributing inbound HTTP traffic.
* **Private Layer:** Isolated EC2 web instances deployed in private subnets, completely shielded from direct public internet access.
* **Egress Routing:** A secure NAT Gateway allowing private instances outbound access to download updates and packages without exposing them to inbound threats.
* **Resilience:** An Auto Scaling Group (ASG) maintaining a highly available cluster that automatically self-heals during instance failures or zone outages via rolling refreshes.

## 🛠️ Tech Stack & Concepts
* **Infrastructure as Code:** Terraform (Version pinned, modular structure)
* **Cloud Provider:** Amazon Web Services (AWS)
* **Networking:** VPC, Public/Private Subnets, Internet Gateway, NAT Gateway, Dynamic Route Tables
* **Compute & Scaling:** EC2, Launch Templates, Auto Scaling Groups (ASG)
* **Security:** Security Group Chaining, Least Privilege Access Rules

## 🚀 How to Deploy

1. Clone the repository:
   ```bash
   git clone [https://github.com/tyrelaws/charlotte-ha-web-arch.git](https://github.com/tyrelaws/charlotte-ha-web-arch.git)
   cd charlotte-ha-web-arch
terraform init
terraform validate
terraform plan
terraform apply --auto-approve
