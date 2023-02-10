# Cloudifytests Infrastructure Installation Steps


This document provides the steps for installing the Cloudifytests product from AWS Marketplace.

## Prerequisites
**kubectl –** A command line tool for working with Kubernetes clusters.

**eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.

##### Minimum requirements to run application on the cluster:-

   You need 4vCPU machine and 4gb ram
   
##### AWS CLI configured with your Access Key and Secret Access Key

### Installation Steps
   
#### Install Kubectl
[Install Kubectl in your local environment](https://kubernetes.io/docs/tasks/tools/)

#### Install Eksctl
[Install eksctl in your local environment](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)


### Deployment steps

#### Cloning the Project

###### Clone the project using the following git command.

       bash
       
       git clone https://github.com/CloudifyLabs/cloudifytests_charts.git
       
### Creating Cluster. (Optional)

###### Use Cluster.yaml file to create the cluster with the following command.

       eksctl create cluster -f <path-to-file>/cluster.yaml
             
       
#### Adding an Ingress Controller
      
###### Add ingress-controller to your cluster using ingress.yaml file.

       kubect apply -f <path-to-file>/deploy-tls-termination.yaml 
       
#### Creating a Namespace 

###### Create a namespace for the project. The namespace will be uesd as $org_name

       kubectl create namespace <your namespace name>
   

### Apply helm using following command:

         helm template . \
    --set s3microservices.AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY> \
    --set s3microservices.AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_KEY> \
    --set urls.BASE_URL=http://cloudifytests-nginx.$orgname.svc.cluster.local \
    --set s3microservices.AWS_BUCKET=<Your_S3_BUCKET_NAME>  \
    --set s3microservices.AWS_DEFAULT_REGION="<Your_AWS_REGION_NAME>" \
    --set ingress.hosts[0]=$ingress_host \
    --set sessionbe.serviceAccountName=$org_name --set nginxhpa.metadata.namespace=$org_name \
    --set be.ORG_NAME=$org_name \
    --set sessionbe.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/cloudifylabs-pvt/marketplace_images:sessionbe_v0.0.1" \
    --set sessionUi.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/cloudifylabs-pvt/marketplace_images"  \
    --set sessionUi.image.tag="sessionui_v0.0.1" \
    --set smcreate.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/cloudifylabs-pvt/marketplace_images:smcreate_v0.0.1"  \
    --set smdelete.image.repository="$ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/cloudifylabs-pvt/marketplace_images:smdelete_v0.0.1" \
    --set sessionmanager.AWS_ECR_IMAGE="public.ecr.aws/r2h8i7a4"   \
    --set smlogsvalues.ORG_NAME=$org_name \
    --set behpa.metadata.namespace=$org_name --set sessionManagaerhpa.metadata.namespace=$org_name \
    --set role.metadata.namespace=$org_name --set roleBinding.metadata.namespace=$org_name \
    --set smcreatehpa.metadata.namespace=$org_name --set smdeletehpa.metadata.namespace=$org_name \
    --set serviceaccount.metadata.namespace=$orgname --set roleBinding.subjects.namespace=$orgname | kubectl create --namespace $org_name -f -


   

   
### Port forward the service 
   
         kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
