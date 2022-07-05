#!/usr/bin/env bash
set -euo pipefail

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIRNAME > /dev/null

JENKINS_DOCKER_IMAGE=${1:-'jenkins/jenkins:lts'}
JENKINS_NAME=${2:-'jenkins'}

function main(){
  run
  getPaswd
}

function run(){
  if [ "$(docker ps | grep ${JENKINS_NAME})" ]; then
    echo "Removing previous Jenkins ..."
    docker rm ${JENKINS_NAME} -f 
  fi

  if [ "$(docker volume ls | grep jenkins_home)" ]; then
    echo "Removing previous jenkins_home volume ..."
    docker volume rm jenkins_home
  fi

  echo "Running Jenkins ..."
  docker run --name ${JENKINS_NAME} -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home \
  --restart=on-failure \
  ${JENKINS_DOCKER_IMAGE}
}

function getPaswd(){
  echo "Getting Jenkins inicial admin password ..."
  echo "*****************"
  echo "Initial password:"
  for i in {1..5}; do docker container exec ${JENKINS_NAME} cat /var/jenkins_home/secrets/initialAdminPassword 2> /dev/null && break || sleep 5; done
  echo "*****************"
}

main

popd > /dev/null
