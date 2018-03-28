#!/bin/bash
set -x -e
source ../env.sh
docker build . -t docker-registry-default.apps.na37.openshift.opentlc.com/$CICD_PROJECT/jenkins-slave-maven-appdev:v3.7
docker login -u someUser -p $(oc whoami -t) docker-registry-default.apps.na37.openshift.opentlc.com
docker push --disable-content-trust docker-registry-default.apps.na37.openshift.opentlc.com/$CICD_PROJECT/jenkins-slave-maven-appdev:v3.7
oc label is/jenkins-slave-maven-appdev role jenkins-slave