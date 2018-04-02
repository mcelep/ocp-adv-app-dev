#!/bin/bash
set -x
source ../env.sh
oc project $CICD_PROD

#MongoDB
oc create -f cm_mongodb.yml && oc new-app -f ss_mongodb.yml

#NationalParks
oc new-app -f ../dev/template_nationalparks.yml -p APP_NAME=nationalparks-blue
oc patch dc/nationalparks-blue --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'

oc new-app -f ../dev/template_nationalparks.yml -p APP_NAME=nationalparks-green
oc patch dc/nationalparks-green --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'


#MLBParks
oc new-app -f ../dev/template_mlbparks.yml -p APP_NAME=mlbparks-blue
oc patch dc/mlbparks-blue --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'

oc new-app -f ../dev/template_mlbparks.yml -p APP_NAME=mlbparks-green
oc patch dc/mlbparks-green --type=json \
 -p '[{"op": "add", "path": "/spec/template/spec/containers/0/env/5", "value":{"name": "DB_REPLICASET","valueFrom": {"configMapKeyRef": {"key": "database-rs","name": "mongodb-configmap"}}} }]'



#Parksmap
oc new-app -f ../dev/template_parksmap.yml  -p APP_NAME=parksmap-blue
oc new-app -f ../dev/template_parksmap.yml  -p APP_NAME=parksmap-green

