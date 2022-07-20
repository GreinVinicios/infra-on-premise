FROM jenkins/jenkins:lts
USER root

# Docker script
RUN apt update
RUN apt install -y curl
RUN curl -fsSL https://get.docker.com -o get-docker.sh
RUN sh ./get-docker.sh
RUN usermod -aG docker jenkins

RUN apt-get install -y uidmap

USER jenkins

RUN dockerd-rootless-setuptool.sh install
