FROM alpine:edge

RUN apk add --update --no-cache ansible openssh
COPY keys/id_rsa /root/.ssh/
RUN chmod -R 700 /root/.ssh
COPY files/ansible/.ansible.cfg /root

WORKDIR /homework
