# Cloudifytests Infrastructure Installation Steps


This document provides the steps for installing the Cloudifytests product from AWS Marketplace.

## Prerequisites
**kubectl –** A command line tool for working with Kubernetes clusters.

**eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.

**helm v3 -** A command line tool that enables user to install application on Kubernetes Cluster.

##### Minimum requirements to run application on the cluster:-

   You need 4vCPU machine and 4gb ram
   
##### AWS CLI configured with your Access Key and Secret Access Key

### Installation Steps
   
#### Install Kubectl
[Install Kubectl in your local environment](https://kubernetes.io/docs/tasks/tools/)

#### Install Eksctl
[Install eksctl in your local environment](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

#### Install Helm V3

[Install Helm V3 in your local environment](https://helm.sh/docs/intro/install/)


       
### Creating Cluster. (Optional)

###### Use Cluster.yaml file to create the cluster with the following command.

       eksctl create cluster -f <path-to-file>/cluster.yaml
             
       
#### Adding an Ingress Controller
      
###### Add ingress-controller to your cluster using ingress.yaml file.

       kubect apply -f <path-to-file>/deploy-tls-termination.yaml 
       
### Quick Launch 
       The Quick Launch method allows you to deploy Cloudify Tests using a shell script. The script will prompt you for the following required inputs:


      |    Field          |      Required / Optional    |
      | ------------------|-----------------------------|
      | Namespace Name    |   Required                  |
      | AWS Access Key    |   Required                  |
      | AWS Secret Key    |   Required                  |
      | Base Url          |   Required                  |
      | Ingress Host      |   Required                  |
      | S3 Bucket name    |   Required                  |
      | AWS Default Region|   Required                  |
      | AWS ECR Image     |   Required                  |
      | Cluster Name      |   Required                  |
      | Tag for sessionbe |   Required                  |
      | Tag for sessionui |   Required                  |
      | Tag for smcreate  |   Required                  |
      | Tag for smdelete  |   Required                  |
      
      All of the fields listed above must be provided by the user in order for the script to run correctly.
      
### To launch Cloudify Tests using the Quick Launch method, run the following command:


       ./quicklaunch.sh

Once the script has completed execution, the application will be deployed to your Kubernetes cluster in the specified namespace.

Please note that the quick launch script assumes that you have kubectl and helm installed on your machine, and that you have access to a Kubernetes cluster.


 
### Port forward the service 
   
         kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
