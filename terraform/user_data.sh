#!/bin/bash

# Install the CodeDeploy agent
sudo yum install -y ruby
sudo yum install -y wget
cd /home/ubuntu
wget https://aws-codedeploy-eu-west-3.s3.eu-west-3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto

# Remove the default index.html file provided by Nginx
cd ../../usr/share/nginx/html
sudo rm -rf index.html