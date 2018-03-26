# CI/CD POC on Openshift

In this repo, we demonstrate a fully integrated CI/CD pipeline using a source code control system (Gogs), an artifact repository (Nexus3), and code analysis (SonarQube), and deployed to production in a blue-green strategy orchestrated by Jenkins.

## Project Setup
Change *env.sh* with a preferred company and project prefix and then run *setup.sh*. This script creates cicd,dev,prod projects and assings the necessary roles required in the next steps.

## Install CI/CD componets
In this stage we setup infrastructure components that build up the CI/CD pipeline.

### Nexus
In order to provision a Nexus instance, run the script in nexus directory:
```
cd nexus && ./provision.sh
```

Setup nexus artifacts by calling *execute_setup_nexus.sh*

### Sonarqube
In order to provision SonarQube, run the script in sonarqube directory:
```
cd sonarqube && ./provision.sh
```

### Gogs
In order to create a Gogs repository, run the script in gogs directory:
```
cd gogs && ./provision.sh
```

After making sure that gogs is running, open the url returned by *get_route* script in gogs directory. Click on register and create a new user.

Login with the newly created user and create a new **private** repo. 

Checkout app repository from this [repo](https://github.com/wkulhanek/ParksMap.git) and push it onto the private repo created in the preveious step:

```
git clone https://github.com/wkulhanek/ParksMap.git
cd ParksMap && git remote add gogs $PRIVATE_REPO_URL
git push gogs
```
Update maven settings in order to point maven to the newly created Nexus.
```
sed -i.bak 's|'nexus3-xyz-nexus.apps.wk.example.opentlc.com'|'nexus3-mitzicom-poc-cicd.apps.na37.openshift.opentlc.com'|g' nexus_settings.xml
sed -i.bak 's|'nexus3.xyz-nexus.svc.cluster.local'|'nexus3.mitzicom-poc-cicd.svc.cluster.local'|g' nexus_settings_openshift.xml
rm *.bak
```




For copying the gogs configuration after setting it up:
```
oc cp $(oc get pods --selector deploymentconfig=gogs -o json | jq -r '.items[0].metadata.name'):/opt/gogs/custom/conf/app.ini app.ini
```


### Jenkins

## Prepare Applications


