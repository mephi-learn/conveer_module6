#!/bin/sh

docker rmi backend1 backend2 backend3 frontend ansible
docker network rm homework
rm -rf docker/keys
