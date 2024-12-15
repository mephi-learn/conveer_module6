#!/bin/sh

cd docker || exit
docker build -t ansible -f dockerfiles/ansible.dockerfile .
cd ..
