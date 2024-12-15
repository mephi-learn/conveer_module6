#!/bin/sh

cd playbook || exit
ansible ansible-playbook -i inventory/homework.yml homework.yml
cd ..
