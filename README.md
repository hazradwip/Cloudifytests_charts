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
--set s3microservices.AWS_ACCESS_KEY_ID=$aws_key \
--set s3microservices.AWS_SECRET_ACCESS_KEY=$aws_secret_key \
--set urls.BASE_URL=$base_url \
--set s3microservices.S3_BUCKET=$s3_bucket \
--set s3microservices.AWS_DEFAULT_REGION=$aws_region \
--set ingress.hosts[0]=$ingress_host \
--set sessionbe.serviceAccountName=$org_name --set nginxhpa.metadata.namespace=$org_name \
--set be.ORG_NAME=$org_name \
--set sessionbe.image.repository="$ecr_repo:sessionbe_$sessionbe_tag" \
--set sessionUi.image.repository="$ecr_repo" \
--set sessionUi.image.tag="sessionui_$sessionui_tag" \
--set smcreate.image.repository="$ecr_repo:smcreate_$smcreate_tag" \
--set smdelete.image.repository="$ecr_repo:smdelete_$smdelete_tag" \
--set sessionmanager.AWS_ECR_IMAGE="$public_ecr_repo" \
--set smlogsvalues.ORG_NAME=$org_name \
--set behpa.metadata.namespace=$org_name --set sessionManagaerhpa.metadata.namespace=$org_name \
--set role.metadata.namespace=$org_name --set roleBinding.metadata.namespace=$org_name \
--set smcreatehpa.metadata.namespace=$org_name --set smdeletehpa.metadata.namespace=$org_name \
--set serviceaccount.metadata.namespace=$org_name \
--set roleBinding.subjects.namespace=$org_name | kubectl create --namespace $org_name -f -

   

   
### Port forward the service 
   
         kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
