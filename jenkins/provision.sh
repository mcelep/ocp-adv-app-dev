#!/bin/bash
# Import a template into OCP and create a new app based on the template
set -ex
source ../env.sh
oc project $CICD_PROJECT
oc new-app jenkins-persistent --param ENABLE_OAUTH=true --param MEMORY_LIMIT=2Gi --param VOLUME_CAPACITY=4Gi
