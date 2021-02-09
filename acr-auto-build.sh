#!/usr/bin/env bash
docker_imagename="httpd"
ecrRepoName="node-api"
ecrURL="xxxxxxxxx.dkr.ecr.eu-west-1.amazonaws.com"
awsECR="$ecrURL/$ecrRepoName"
docker pull $docker_imagename
docker tag $docker_imagename $awsECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin $ecrURL
docker push $awsECR
docker logout $ecrURL

# Require pakages

# 1. awscli
# 2. iam access key and secret key
# 3. execute the scripts
