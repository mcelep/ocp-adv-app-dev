#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROJECT

./setup_nexus3.sh admin admin123 http://$(oc get route nexus3 --template='{{ .spec.host }}')

