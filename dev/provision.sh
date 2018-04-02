#!/bin/bash
set -x
source ../env.sh
oc project $CICD_PROD

#MongoDB
oc create -f cm_mongodb.yml && oc new-app -f template_mongodb.yml

#Secrets
oc create -f gogs_repo_secret.yml

#NationalParks
oc process -f template_nationalparks.yml | oc create -f -
oc new-build --binary=true --name=nationalparks --image-stream=redhat-openjdk18-openshift:1.2

#MLBParks
oc process -f template_mlbparks.yml | oc create -f -
oc new-build --binary=true --name=mlbparks --image-stream=jboss-eap70-openshift:1.6


#Parksmap
oc process -f template_parksmap.yml | oc create -f -
oc new-build --binary=true --name=parksmap --image-stream=redhat-openjdk18-openshift:1.2




