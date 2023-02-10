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


### Deployment steps

       
### Creating Cluster. (Optional)

###### Use Cluster.yaml file to create the cluster with the following command.

       eksctl create cluster -f <path-to-file>/cluster.yaml
             
       
#### Adding an Ingress Controller
      
###### Add ingress-controller to your cluster using ingress.yaml file.

       kubect apply -f <path-to-file>/deploy-tls-termination.yaml 
       

       
##### Quick Launch Script
This repository comes with a quick launch script (quicklaunch.sh) that automates the process of deploying the application to a Kubernetes cluster.

### To use the script, follow these steps:

    Make the script executable:
    chmod +x quicklaunch.sh
## Run the script:

     ./quicklaunch.sh
## You will be prompted to enter the following information:

    Namespace name
    AWS access key
    AWS secret key
    Base URL
    Ingress host
    AWS S3 bucket name
    AWS default region
    AWS ECR image repository
    Tag for sessionbe
    Tag for sessionui
    Tag for smcreate
    Tag for smdelete
    Cluster name


Once the script has completed execution, the application will be deployed to your Kubernetes cluster in the specified namespace.

Please note that the quick launch script assumes that you have kubectl and helm installed on your machine, and that you have access to a Kubernetes cluster.


 
### Port forward the service 
   
         kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
