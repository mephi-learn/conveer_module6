FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends openssh-server python3 && apt-get clean && rm -rf /var/lib/apt/lists/*
ADD files/server/docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh && docker-entrypoint.sh
COPY keys/id_rsa.pub /root/.ssh/authorized_keys

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
