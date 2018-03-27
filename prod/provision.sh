#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROD

#MongoDB
oc create -f cm_mongodb.yml && oc new-app -f ss_mongodb.yml

#NationalParks

#MLBParks


#Parks
#oc new-app -f  ../dev/template_parks.yml