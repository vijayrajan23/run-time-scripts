#!/usr/bin/env bash

REPOSITORYNAME=order-management-service
BRANCHNAME=temp-production
USERNAME=username
PASSWORD=password

# Remove the existing directory

if [ -d "$REPOSITORYNAME" ]; then
    printf '%s\n' "Removing DIrectory ($REPOSITORYNAME)"
    rm -rf "$REPOSITORYNAME"
fi

# Clone the repository

git clone -b ${BRANCHNAME} https://${USERNAME}:${PASSWORD}@github.com/Maveric-Digital/order-management-service.git

# docker buil and update

docker-compose up -d
