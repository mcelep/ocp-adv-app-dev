#!/bin/bash
# Import a template into OCP and create a new app based on the template
set -ex
source env.sh

oc new-project $CICD_PROJECT --display-name "Demo CI/CD"
oc new-project $DEV_PROJECT --display-name "Demo App/Development"
oc new-project $PROD_PROJECT --display-name "Demo App/Production"

oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:jenkins -n $DEV_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:default -n $DEV_PROJECT

oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:jenkins -n $PROD_PROJECT
oc policy add-role-to-user edit system:serviceaccount:$CICD_PROJECT:default -n $PROD_PROJECT
