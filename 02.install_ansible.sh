#!/bin/sh

cd docker || exit
docker build -t ansible -f dockerfiles/ansible.dockerfile .
alias ansible="docker run --net homework --rm -v .:/homework ansible"
cd ..
