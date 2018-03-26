#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROJECT

oc get route nexus3 --template='{{ .spec.host }}'
