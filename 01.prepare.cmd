@echo off

del /Q docker\keys
mkdir docker\keys
powershell -command "ssh-keygen -t rsa -b 4096 -f docker/keys/id_rsa -q -N '\"\"'"
docker network create homework
rem docker build -t ansible -f docker/ansible .
rem alias ansible "docker run --rm -v ./keys:/homework ansible ansible"