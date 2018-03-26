#!/bin/bash
set -ex
source ../env.sh
oc project $PROD_PROJECT

oc new-app -f ss_mongodb.yml
