# Node.js Web Application with CI/CD on AWS

![CI/CD Workflow](https://img.shields.io/badge/GitHub-Actions-blue?logo=github-actions&style=for-the-badge)
![Terraform](https://img.shields.io/badge/Terraform-623CE4?logo=terraform&style=for-the-badge)
![AWS](https://img.shields.io/badge/AWS-orange?logo=amazon-aws&style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&style=for-the-badge)

---

## Project Overview

This repository demonstrates how to deploy a **Node.js web application** using **Infrastructure as Code (IaC)** with **Terraform**, integrated with **CI/CD pipelines** via **GitHub Actions**.  

The pipeline automatically:  
1. Builds a Docker image of the app  
2. Pushes it to **AWS ECR**  
3. Pulls and runs it on an **EC2 instance**  

---

## AWS IAM Roles / Permissions

For this project, the following IAM roles/policies are required:

### 1. GitHub Actions (CI/CD) Role
- **Purpose:** Allow the workflow to push Docker images to ECR.
- **Permissions / Policy:**
  - `AmazonEC2ContainerRegistryFullAccess`
  - `IAM:PassRole` (if needed)
- **Configured via:** GitHub Secrets with AWS Access Key & Secret.

### 2. EC2 Instance Role
- **Purpose:** Allow EC2 to pull Docker images from ECR and run containers.
- **Attached IAM Instance Profile**
- **Permissions / Policy:**
  - `AmazonEC2ContainerRegistryReadOnly`
  - `CloudTrail:LookupEvents` (optional)
  - `iam:CreateServiceLinkedRole` (for ECR replication if used)

---

## Step-by-Step Deployment

### 1. Clone the repository

```bash
git clone https://github.com/rizkypamungkas/simple-iac-docker-ci-cd.git
cd simple-iac-docker-ci-cd
2. Configure AWS credentials
Set your AWS Access Key ID, Secret Access Key, and Region as environment variables or GitHub Secrets:

bash
Copy code
export AWS_ACCESS_KEY_ID=<your-access-key-id>
export AWS_SECRET_ACCESS_KEY=<your-secret-access-key>
export AWS_REGION=<your-region>
Also configure EC2 info for GitHub Actions:

EC2_INSTANCE_IP

EC2_USER

EC2_PRIVATE_KEY

3. Apply Terraform to provision resources
bash
Copy code
cd terraform
terraform init
terraform plan
terraform apply
Terraform will create:

ECR repository

IAM roles & policies

EC2 instance (with IAM instance profile attached)

Output will include the public IP of the EC2 instance.

4. CI/CD Workflow
After pushing changes to main branch, the workflow will automatically:

Checkout the repo

Configure AWS credentials

Login to ECR

Build Docker image

Push Docker image to ECR

SSH into EC2 and deploy container

Workflow file: .github/workflows/deploy.yml

5. Access your app
Open your browser and navigate to:

cpp
Copy code
http://<EC2_PUBLIC_IP>
Highlights
Node.js app with Docker

Fully automated CI/CD using GitHub Actions

Infrastructure as Code via Terraform

Clear IAM role separation for security