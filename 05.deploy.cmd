cd playbook
docker run --net homework --rm -v .:/homework ansible ansible-playbook -i inventory/homework.yml homework.yml
cd ..
