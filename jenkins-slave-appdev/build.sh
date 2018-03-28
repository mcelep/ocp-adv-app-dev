#!/bin/bash
set -x -e
source ../env.sh
docker build . -t jenkins-slave-maven-appdev:v3.7
skopeo copy --dest-tls-verify=false --dest-creds="$(oc whoami):$(oc whoami -t)" docker-daemon:jenkins-slave-maven-appdev:v3.7 docker://docker-registry-default.apps.na37.openshift.opentlc.com/$CICD_PROJECT/jenkins-slave-maven-appdev:v3.7
