#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROJECT && oc get routes -l app=gogs
