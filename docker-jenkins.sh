#!/usr/bin/env bash

ContainerName=userms
imageName=ulapi
GITUSER=xxxxxxxxx
GITPASSWORD=xxxxxxxx
PATHS=$(pwd)
REPOSITORY=userms

# Remove the old directories
echo -e "\e[1;31m Remove the old Directory \e[0m"
rm -rf "$PATHS"/tscout_userloginapi

# Clone the repositary
echo -e "\e[1;31m Clone the Repositary \e[0m"
git clone -b "$2" "https://$GITUSER:$GITPASSWORD@bitbucket.org/xxxxxx/xxxxxxxx.git"

echo -e "\e[1;31m Change the directory \e[0m"
cd tscout_userloginapi

# Docker image build
echo -e "\e[1;30m Docker image build process \e[0m"
docker build -t $imageName:$1 .

# Container status get
container=`docker ps -a -f name=$ContainerName -q`

# If exits remove the docker conatainer
echo -e "\e[1;31m Remove the existing container \e[0m"
if [[ "$container" ]]
then
    echo -e "\e[1;32m Remove the existing container \e[0m"
    docker rm -f $container
else
    echo -e "\e[1;31m Container was not found \e[0m"
fi


# docker container start with latest build 
echo -e "\e[1;31m Run the latest container \e[0m"
docker run -d --name $ContainerName -p 9002:9002 $imageName:$1

# Check docker container running or not
echo -e "\e[1;31m Check docker container running or not \e[0m"
if [ "$( docker container inspect -f '{{.State.Running}}' $ContainerName )" == "true" ]; then
    echo -e "\e[1;31m container running now \e[0m"
else
    exit 0
fi

# ssh goole@fourtimes.io 'bash shell.sh $BUILD_NUMBER $BRANCH'
