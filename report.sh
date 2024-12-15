#!/bin/bash

start=none
if [[ -n "$1" ]]; then start="$1"; fi

. ./lib.sh

if [[ "${start}" == "depends" ]]; then
    hint="Устанавливаем зависимости:"
    printexec "dependency" sudo apt install -y docker xfce4-screenshooter curl && sudo groupadd docker && sudo usermod -aG docker ${USER}
fi

hint="Краткое описание:"
printexec "no-exec" "
Адаптация задания из курса системного администрирования:
1. Три backend сервера
2. Один балансирующий frontend сервер
3. При обращении на frontend сервер он последовательно производит перенаправление на один из backend серверов
    по схеме round robin

Логика работы:
1. Посредством docker файла собирается ansible образ (не хотел засорять свою машину всякими питонами)
2. Используя docker-compose и docker файлы, собираются четыре пустых сервера, на которые устанавливаются
    только ssh сервер и python3
3. Через ansible playbook в докере с замамленным каталогом, на три сервера устанавливается и конфигурируется
    apache, а на один сервер - nginx, который конфигурируется для балансировки запроса. Всё запускается
4. Проверяем работу, посредством запуска нескольких curl запросов и отфильтровываем по строке, где присутствует
    название сервера. Если название сервера меняется, значит всё работает
5. Прибираем за собой
"


hint="Репозиторий с исходным кодом:"
printexec "no-exec" https://github.com/mephi-learn/conveer_module6

rm -rf docker/keys
mkdir -p docker/keys
hint="Генерируем ssh ключ:"
printexec "prepare" "ssh-keygen -t rsa -b 4096 -f docker/keys/id_rsa -q -N ''"

hint="Создаём в docker отдельную сеть, чтобы с контейнера ansible иметь доступ к контейнерам серверов:"
printexec "create_network" docker network create homework

cd docker || exit
hint="Создаём образ ansible:"
printexec "install_ansible" docker build -t ansible -f dockerfiles/ansible.dockerfile .

hint="Создаём образа пустых серверов:"
printexec "create_servers" docker-compose build --no-cache

hint="Запускаем сервера:"
printexec "run_servers" docker-compose up -d

cd ../playbook || exit
hint="Настраиваем сервера через ansible playbook и запускаем их:"
printexec "deploy" docker run --net homework --rm -v .:/homework ansible ansible-playbook -i inventory/homework.yml homework.yml

hint="Тестируем работу, поскольку у нас три сервера, то сделав четыре запроса мы вернёмся к первому:"
printexec "test" "
curl http://localhost:53080 2>/dev/null | grep working | grep --color 'backend[0-9]'
curl http://localhost:53080 2>/dev/null | grep working | grep --color 'backend[0-9]'
curl http://localhost:53080 2>/dev/null | grep working | grep --color 'backend[0-9]'
curl http://localhost:53080 2>/dev/null | grep working | grep --color 'backend[0-9]'
"

cd ../docker || exit
hint="Останавливаем контейнеры с серверами:"
printexec "stop_servers" docker-compose down

hint="Прибираем за собой:"
printexec "remove" "docker rmi backend1 backend2 backend3 frontend ansible
docker network rm homework
rm -rf docker/keys"
