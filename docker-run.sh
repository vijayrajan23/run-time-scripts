#!/usr/bin/env bash

container=`docker ps -a -f name=$1 -q`

if [[ "$container" ]]
then
    docker rm -f $container
else
    echo "Container was not found"
fi

# docker container start -> $1
docker run -d --name $1 -p 8080:8080 nginx:$2

if [ "$( docker container inspect -f '{{.State.Running}}' $1 )" == "true" ]; then 
    echo "container running now"
else 
    exit 0
fi


# ssh node@fourtimes.ml 'bash -s' < shell.sh web-server latest
