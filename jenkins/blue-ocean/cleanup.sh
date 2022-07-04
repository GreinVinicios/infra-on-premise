#!/usr/bin/env bash
set -euo pipefail

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIRNAME > /dev/null

function main(){
  container
  network
  volume
}

function container(){
  if [ "$(docker ps | grep jenkins-blueocean)" ]; then
    echo "Removing Jenkins ..."
    docker rm jenkins-blueocean -f 
  fi
}

function network(){
  if [ "$(docker network ls | grep jenkins)" ]; then
    echo "Removing jenkins network ..."
    docker network rm jenkins
  fi
}

function volume(){
  if [ "$(docker volume ls | grep jenkins_home)" ]; then
    echo "Removing jenkins_home volume ..."
    docker volume rm jenkins_home
  fi

  if [ "$(docker volume ls | grep jenkins_certs)" ]; then
    echo "Removing jenkins_certs volume ..."
    docker volume rm jenkins_certs
  fi
}


main

popd > /dev/null