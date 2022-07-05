#!/usr/bin/env bash
set -euo pipefail

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIRNAME > /dev/null

DOCKER_USER=${1:-''}'/'
JENKINS_VERSION=2.346.1-1
JENKINS_IMAGENAME=jenkins-blueocean

function main(){
  build
  network
  volume
  run
  getPaswd
}

function build(){
  if [[ ${DOCKER_USER} = "/" ]]; then
    echo "Building ${JENKINS_IMAGENAME}:${JENKINS_VERSION} ..."
    docker build -t ${JENKINS_IMAGENAME}:${JENKINS_VERSION} .
  else
    echo "Building ${DOCKER_USER}${JENKINS_IMAGENAME}:${JENKINS_VERSION} ..."
    docker build -t ${DOCKER_USER}${JENKINS_IMAGENAME}:${JENKINS_VERSION} . &&
    echo "Pushing ${DOCKER_USER}${JENKINS_IMAGENAME}:${JENKINS_VERSION} ..."
    docker push ${DOCKER_USER}${JENKINS_IMAGENAME}:${JENKINS_VERSION}
  fi
}

function network(){
  if [ ! "$(docker network ls | grep jenkins)" ]; then
    echo "Creating jenkins network ..."
    docker network create jenkins
  fi
}

function volume(){
  if [ ! "$(docker volume ls | grep jenkins_home)" ]; then
    echo "Creating jenkins_home volume ..."
    docker volume create jenkins_home
  fi

  if [ ! "$(docker volume ls | grep jenkins_certs)" ]; then
    echo "Creating jenkins_certs volume ..."
    docker volume create jenkins_certs
  fi
}

function run(){
  echo "Running Jenkins ..."
  docker run --name ${JENKINS_IMAGENAME} --restart=on-failure --detach --privileged \
    --network jenkins --env DOCKER_HOST=tcp://docker:2376 \
    --env DOCKER_CERT_PATH=/certs/client --env DOCKER_TLS_VERIFY=1 \
    --publish 8080:8080 --publish 50000:50000 \
    --volume jenkins_home:/var/jenkins_home \
    --volume jenkins_certs:/certs/client:ro \
    ${DOCKER_USER}${JENKINS_IMAGENAME}:${JENKINS_VERSION}
}

function getPaswd(){
  echo "Getting Jenkins inicial admin password ..."

  for i in {1..5}; do docker container exec ${JENKINS_IMAGENAME} cat /var/jenkins_home/secrets/initialAdminPassword 2> /dev/null && break || sleep 5; done

  echo "Open http://127.0.0.1:8080/"
}

main

popd > /dev/null
