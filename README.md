# AWS INFRASTRUCTURE & NODE JS APPLICATION DEPLOYMENT USING TERRAFORM 
[![Terraform Checks](https://github.com/aswath-pt/aswath-nodejs-assesment/actions/workflows/terrform-pipeline.yml/badge.svg)](https://github.com/aswath-pt/aswath-nodejs-assesment/actions/workflows/terrform-pipeline.yml)

![Architecture](https://github.com/aswath-pt/nodetest/blob/master/Aswath_architecture.jpg)
## Code Fixes and feature adding
```
- Clone the repository and create a sandbox branch sandbox-<name>-<feature>
- Add the code changes commit push and raise a PR
  - Post PR is Raised Github actions pipeline will be triggered on sandbox branch
  - Pipeline will Scan the code for vulnerabilities and code quality using tfsec
  - Terraform plan will be executed to check the code is working
  - PR will be merged post passing all the checks
```

## FILE STRUCTURE

| Files  | Description |
| ------------- | ------------- |
| backend-vars  | This folder contains the variables for statefile backend configuration.  |
| infra-vars  | This folder contains the variables for provisioning infrastructure in diffrent regions.  |
| modules | This folder contains the modules and terraform files required. |
| remote-state | This folder contains the terraform files to create s3 and dynamodb tables for securely storing the state file and state lock. |
```
.
├── backend-vars 
│   ├── backend-dev-use1.tfvars
│   └── backend-dev-use2.tfvars
├── infra-vars 
│   ├── assesment-dev-use1.tfvars
│   └── assesment-dev-use2.tfvars
├── modules
│   ├── ec2
│   │   ├── main.tf
│   │   ├── output.tf
│   │   └── variable.tf
│   ├── networking
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variable.tf
│   └── s3
│       ├── main.tf
│       ├── output.tf
│       └── variables.tf
├── remote-state 
│   ├── main.tf
│   ├── sandbox.tfvars
│   └── variable.tf
├── data.tf
├── ec2.tf
├── iam.tf
├── locals.tf
├── main-backend.tf
├── main.tf
├── networking.tf
├── provider.tf
├── s3.tf
├── userdata.sh.tpl
└── variables.tf
```
## Prerequisites
```
1. Terraform
2. AWS Account
```

## Steps to execute the code

### Backend Setup
```
cd remote-state
terraform init
terraform plan --var-file=sandbox.tfvars
terraform apply --var-file=sandbox.tfvars

This will create the S3 Bucket to store the state file and Dynamodb table to hold the state lock
```
### Infrastructure Provisioning Steps
```
cd <main-folder>
terraform init --backend-config=backend-vars/backend-<env>-<region>.tfvars
terraform plan --var-file=infra-vars/assesment-<env>-<region>.tfvars
terraform apply --var-file=infra-vars/assesment-<env>-<region>.tfvars
```
### Nodejs WEB application

Git Repo for Application code: https://github.com/aswath-pt/node-s3-upload.git

Web application will allow user to upload files in s3 via browser

Post infrastructure is deployed successfully access the web application using

URL: s3upload.assessnode.tech

[Access the WEB Application](https://s3upload.assessnode.tech).



### Improvements that can be done

- Application can be deployed to autoscaling group using aws codedeploy and docker
- Instead of EC2 we can provision EKS and deploy the application using helm charts 