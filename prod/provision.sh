#!/bin/bash
set -ex
source ../env.sh
oc project $CICD_PROD

#MongoDB
oc create -f cm_mongodb.yml && oc new-app -f ss_mongodb.yml

#NationalParks
oc new-app -f ../dev/template_nationalparks.yml
oc patch dc/nationalparks --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'

#MLBParks
oc new-app -f ../dev/template_mlbparks.yml
oc patch dc/mlbparks --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'


#Parks
oc new-app -f ../dev/template_parks.yml