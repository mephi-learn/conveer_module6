#!/bin/sh

rm -rf docker\keys
mkdir -p docker/keys
ssh-keygen -t rsa -b 4096 -f docker/keys/id_rsa -q -N ''
docker network create homework
