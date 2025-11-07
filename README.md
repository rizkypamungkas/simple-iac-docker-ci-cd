# Node.js Web Application with CI/CD on AWS

![CI/CD Workflow](https://img.shields.io/badge/GitHub-Actions-blue?logo=github-actions&style=for-the-badge)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?logo=terraform&style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-orange?logo=amazon-aws&style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&style=for-the-badge)

---

This repository demonstrates how to **deploy a Node.js web application** using **Terraform (Infrastructure as Code)** and a **simple CI/CD pipeline with GitHub Actions**.  

The pipeline builds a Docker image, pushes it to ECR, and deploys it to an EC2 instance.

---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Clone Repository](#clone-repository)  
3. [GitHub Secrets Setup](#github-secrets-setup)  
4. [Terraform Infrastructure Setup](#terraform-infrastructure-setup)  
5. [AWS IAM Roles and Policies](#aws-iam-roles-and-policies)  
6. [CI/CD Workflow](#ci-cd-workflow)  
7. [EC2 SSH Access](#ec2-ssh-access)  
8. [Verify Deployment](#verify-deployment)  
9. [Prerequisites](#prerequisites)  
10. [Key Features](#key-features)

---

## Project Overview

This project demonstrates a **full DevOps flow** for deploying a Node.js application:

- Provision AWS infrastructure with Terraform  
- Create IAM roles for secure access to AWS resources  
- Build and push Docker images to AWS ECR  
- Deploy and run containers on EC2 instances  
- Simple CI/CD pipeline using GitHub Actions  
- SSH access for troubleshooting and manual verification  

---

## Clone Repository

```bash
git clone https://github.com/username/simple-iac-docker-ci-cd.git
cd simple-iac-docker-ci-cd
```

---

## GitHub Secrets Setup

Go to **Settings → Secrets → Actions** and add the following secrets:

- `AWS_ACCESS_KEY_ID` → IAM user for GitHub Actions  
- `AWS_SECRET_ACCESS_KEY` → IAM user for GitHub Actions  
- `AWS_REGION` → e.g., `ap-southeast-1`  
- `EC2_USER` → e.g., `ubuntu` (depends on AMI)  
- `EC2_PRIVATE_KEY` → Private key for EC2 SSH  

---

## Terraform Infrastructure Setup

1. Install Terraform (v1.x) if not already installed.  
2. Initialize Terraform:
```bash
terraform init
```
3. Check the planned resources:
```bash
terraform plan
```
4. Apply the infrastructure:
```bash
terraform apply
```

**Terraform will create:**

- **EC2 instance** with Security Group (HTTP 80 + SSH 22)  
- **ECR repository**  
- **IAM Role** for EC2  
- **Security Groups**  

---

## AWS IAM Roles and Policies

### 1️⃣ GitHub Actions IAM User (Manual)

- **Purpose:** Push Docker images to ECR  
- **Permissions:** `AmazonEC2ContainerRegistryFullAccess`  
- **Configured via:** GitHub Secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`)  

⚠️ This user is **not created via Terraform**.  

---

### 2️⃣ IAM Role for EC2 (Terraform-managed)

- **Purpose:** Pull Docker images from ECR securely and run containers  
- **Permissions:** `AmazonEC2ContainerRegistryReadOnly`  
- **Terraform Steps:**  
  1. Create `aws_iam_role` with EC2 assume role policy  
  2. Attach `AmazonEC2ContainerRegistryReadOnly` via `aws_iam_role_policy_attachment`  
  3. Create **Instance Profile** and attach to EC2 instance  

---

## CI/CD Workflow (GitHub Actions)

1. **Trigger:** Push to `main` branch  
2. **Steps:**  
   - Checkout repository  
   - Configure AWS credentials  
   - Login to Amazon ECR  
   - Build Docker image and tag with `github.sha`  
   - Push image to ECR  
   - SSH into EC2  
   - Pull latest image from ECR  
   - Stop old container (if exists)  
   - Run new container on port 80 → mapped to app port 3000  

3. **Optional:** Manual trigger via **Actions → Run workflow**.  

---

## EC2 SSH Access

To verify or debug the deployment:

```bash
ssh -i path/to/key.pem ubuntu@<EC2_PUBLIC_IP>
```

**Commands to check container:**
```bash
docker ps
docker logs <container_id>
```

**Stop and remove old container manually (if needed):**
```bash
docker stop app || true
docker rm app || true
```

---

## Verify Deployment

From local machine or browser:

```bash
curl http://<EC2_PUBLIC_IP>/
```

Expected response:
```
🚀 Hello from Node.js running in Docker on EC2!
```

---

## Prerequisites

### Local Machine / Developer

- Git  
- Node.js & npm  
- Docker  
- Terraform  
- AWS CLI  
- SSH client  

### AWS Account

- IAM user/role with permissions: `ec2:*`, `ecr:*`, `iam:*` (if Terraform manages IAM)  
- Security Group allowing HTTP (80) and SSH (22)  

### GitHub

- Repository with workflow  
- GitHub Secrets as described above  

---

## Key Features

- End-to-end deployment pipeline for Node.js apps  
- Infrastructure as Code (Terraform)  
- Dockerized applications  
- Simple CI/CD with GitHub Actions  
- Secure EC2 access with IAM roles  
- Step-by-step reproducible process

