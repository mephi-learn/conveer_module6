#!/bin/sh

cd docker || exit
docker-compose build --no-cache
cd ..
rm -rf docker\keys
