#!/bin/bash

#installing docker
yum install -y docker

# Adding ec2-user users to docker group
gpasswd -M ec2-user docker

#Starting service
systemctl start docker
systemctl enable docker
systemctl start sysstat
systemctl enable sysstat


# Installing docker compose
curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
