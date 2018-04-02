#!/bin/bash
set -ex
source env.sh

oc new-project $CICD_PROJECT --display-name "Demo CI/CD"
oc new-project $DEV_PROJECT --display-name "Demo App/Development"
oc new-project $PROD_PROJECT --display-name "Demo App/Production"

oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:jenkins -n $DEV_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:default -n $DEV_PROJECT

oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:jenkins -n $PROD_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:default -n $PROD_PROJECT
oc policy add-role-to-user system:image-puller system:serviceaccount:$PROD_PROJECT:default --namespace=$DEV_PROJECT

oc policy add-role-to-user view --serviceaccount=default -n $PROD_PROJECT
oc policy add-role-to-user view --serviceaccount=default -n $DEV_PROJECT
