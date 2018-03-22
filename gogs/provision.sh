#!/bin/bash
# Import a template into OCP and create a new app based on the template
set -ex

oc new-app -f template-gogs.yml 

