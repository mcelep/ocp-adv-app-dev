#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROJECT
oc new-app -f template-gogs.yml 

