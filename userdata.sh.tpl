#!/bin/bash

# Install dependencies
sudo yum update
sudo yum install -y git
sudo yum install https://rpm.nodesource.com/pub_16.x/nodistro/repo/nodesource-release-nodistro-1.noarch.rpm -y
sudo yum install nodejs -y --setopt=nodesource-nodejs.module_hotfixes=1

#Application run
git clone ${repo}
cd ${app_path}
sudo echo "
 PORT=${port}
 S3_REGION=${region}
 S3_BUCKET=${s3_name}"
sudo npm install express dotenv formidable @aws-sdk/lib-storage @aws-sdk/client-s3
sudo nohup node index.js &


