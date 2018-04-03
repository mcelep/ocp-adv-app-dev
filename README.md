# CI/CD POC on Openshift

In this repo, we demonstrate a fully integrated CI/CD pipeline using a source code control system (Gogs), an artifact repository (Nexus3), and code analysis (SonarQube), and deployed to production in a blue-green strategy orchestrated by Jenkins.

## Project Setup
Change *env.sh* with a preferred company and project prefix and then run *setup.sh*. This script creates cicd,dev,prod projects and assings the necessary roles required in the next steps.

## Install CI/CD componets
In this stage we setup infrastructure components that build up the CI/CD pipeline. These components reside in their own(**cicd**) project.

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
sed -i.bak 's|'nexus3.xyz-nexus.svc.cluster.local'|'nexus3.mitzicom-poc-cicd.svc.cluster.local:8081'|g' nexus_settings_openshift.xml
rm *.bak
```


For copying the gogs configuration after setting it up:
```
oc cp $(oc get pods --selector deploymentconfig=gogs -o json | jq -r '.items[0].metadata.name'):/opt/gogs/custom/conf/app.ini app.ini
```


### Jenkins
Prepare the slave image which includes *skopeo* binary by running the "build.sh" in *jenkins-slave-appdev* folder.

After this create a new project using the newlry created image. You can do this by going into *Manage Jenkins>Configure System* and then adding a new Kubernetes pod template. In our example, we call the new container image *maven-appdev*. 
![Kubernetes pod template](../images/add_kube_pod_template.png)

In order to make the build go faster(e.g. reuse .m2 folder which includes all dependencies), one can add a persistent volume claim.
![Kubernetes pod template persistent volume](../images/add_kube_pod_template_persistent_volume.png)


## Prepare Openshift
For the apps, we will have one production and one test project.

For setting up the **dev** project, go into the dev folder and run the *provision.sh* script. This script has the following steps:
- Create single instance MongoDB and a configuration map for it
- Create secrets for Gogs access
- Creates a deployment configuration, service, route and binary build configurations for all three applications.

For setting up the **prod** project, go into the prod folder and run the *provision.sh* script. This script has the following steps:
- Create a 3 node stateful set of MongoDB and a configuration map for it
- For each application:
..- Create One route
..- Two services and two deployments configurations for blue/green deployments
- Also noticed that deployment configuration for nationalparks and mlbparks apps are patched because MongoDB configuration for a replica set is slightly different than standalone configuration.(i.e replicaset name needs to be specified.)








