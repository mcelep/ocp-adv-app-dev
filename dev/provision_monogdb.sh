#!/bin/bash
set -ex
source ../env.sh
oc project $DEV_PROJECT

oc new-app mongodb-persistent
