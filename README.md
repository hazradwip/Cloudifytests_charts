# Cloudifytests Infrastructure Installation Guide


This document provides the steps for installing the Cloudifytests product from AWS Marketplace.

## Prerequisite
**kubectl –** A command line tool for working with Kubernetes clusters.

**eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.

Minimum requirements to run application on the cluster:-

   You need 4vCPU machine and 4gb ram
   
 AWS CLI configured with your Access Key and Secret Access Key
   
## Installation Steps
   
### Install Kubectl
[Install Kubectl in your local environment](https://kubernetes.io/docs/tasks/tools/)

### Install Eksctl
[Install eksctl in your local environment](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

   
### Creating a cluster.(Optional)

##### Use Cluster.yaml file to create the cluster

      $ eksctl create cluster -f <path-to-file>/cluster.yaml
      
### Deployment Steps
      
##### Adding Ingress-Controller
###### Add an ingress controller to your cluster using the ingress.yaml file

       $ kubect apply -f <path-to-file>/ingress.yaml    

##### Cloning the Project

###### Clone the project using the following Git command:

         bash
         
       $ git clone https://github.com/CloudifyLabs/cloudifytests_charts.git
       
  
#### Creating a Namespace 
###### Create a namespace for the project. The namespace name will be used as $org_name

       $ Kubectl create namespace <namespace name>
   
#### Applying Helm

###### Apply helm using following command:

        $  helm template . \
        --set s3microservices.AWS_KEY=<YOUR_AWS_ACCESS_KEY> \
        --set s3microservices.AWS_SECRET_KEY=<YOUR_AWS_SECRET_KEY> \
        --set urls.BASE_URL=http://cloudifytests-nginx.$orgname.svc.cluster.local \
        --set s3microservices.AWS_BUCKET=<Your_S3_BUCKET_NAME>  \
        --set s3microservices.AWS_DEFAULT_REGION="<Your_AWS_REGION_NAME>" \
        --set ingress.hosts[0]=$ingress_host \
        --set sessionbe.serviceAccountName=$org_name --set nginxhpa.metadata.namespace=$org_name \
        --set be.ORG_NAMESPACE=$org_name \
        --set sessionbe.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/marketplace_images:sessionbe_v0.0.1" \
        --set sessionUi.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/marketplace_images"  \
        --set sessionUi.image.tag="sessionui_v0.0.1" \
        --set smcreate.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/marketplace_images:smcreate_v0.0.1"  \
        --set smdelete.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/marketplace_images:smdelete_v0.0.1" \
        --set sessionmanager.AWS_ECR_IMAGE="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com"   \
        --set smlogsvalues.ORG_NAME=$org_name \
        --set behpa.metadata.namespace=$org_name --set sessionManagaerhpa.metadata.namespace=$org_name \
        --set role.metadata.namespace=$org_name --set roleBinding.metadata.namespace=$org_name \
        --set smcreatehpa.metadata.namespace=$org_name --set smdeletehpa.metadata.namespace=$org_name \
        --set serviceaccount.metadata.namespace=$orgname --set roleBinding.subjects.namespace=$orgname | kubectl create --namespace $org_name -f -
   

   
### Port forward the service 
   
        $ kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
