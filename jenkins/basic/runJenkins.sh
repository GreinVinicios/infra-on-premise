#!/usr/bin/env bash
set -euo pipefail

DIRNAME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIRNAME > /dev/null

JENKINS_VERSION=lts
JENKINS_IMAGENAME=jenkins

function main(){
  run
  getPaswd
}

function run(){
  echo "Running Jenkins ..."
  docker run --name ${JENKINS_IMAGENAME} -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/${JENKINS_IMAGENAME}:${JENKINS_VERSION}
}

function getPaswd(){
  echo "Getting Jenkins inicial admin password ..."

  for i in {1..5}; do docker container exec ${JENKINS_IMAGENAME} cat /var/jenkins_home/secrets/initialAdminPassword 2> /dev/null && break || sleep 5; done

  echo "Open http://127.0.0.1:8080/"
}

main

popd > /dev/null
