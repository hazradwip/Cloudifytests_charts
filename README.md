# Cloudifytests Infrastructure Installation Steps


This document provides the steps for installing the Cloudifytests product from AWS Marketplace.

## Prerequisites
1.  **kubectl –** A command line tool for working with Kubernetes clusters.

2.  **eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.

3.  **helm v3 -** A command line tool that enables user to install application on Kubernetes Cluster.
  
4.  **AWS CLI configured with your Access Key and Secret Access Key

5.  **Minimum requirements to run application on the cluster:-

        You need 4vCPU machine and 4gb ram

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
       
###### **This repository comes with a quick launch script (quicklaunch.sh) that automates the process of deploying the application to a Kubernetes cluster.**

##### ***Please note that the quick launch script assumes that you have kubectl and helm installed on your machine, and that you have access to a Kubernetes cluster.***


#### You will be prompted to enter the following information:

|    Field          |Description   |      Required / Optional    |
| :------------------:|:-----------------------:|:-----------------:|
| **Namespace Name**    |The name of the namespace to be created.|***Required***|
| **AWS Access Key**    |The Access Key for your AWS Account.|***Required***|
| **AWS Secret Key**    |The Secret Key for your AWS Account.|***Required***|
| **Base Url**          |The Base URL for your application.|***Required***|
| **Ingress Host**      |The Hostname for the Ingress.|***Required***|
| **S3 Bucket name**    |The name of S3 bucket to use.|***Required***|
| **AWS Default Region**|The default region for your AWS Account.|***Required***|
| **AWS ECR Image**     |The name of the ECR image repository to use. |***Required***|
| **Tag for sessionbe** |The tag for SessionBe Image|***Required***|
| **Tag for sessionui** |The tag for SessionUI Image|***Required***|
| **Tag for smcreate**  |The tag for SmCreate Image|***Required***|
| **Tag for smdelete**  |The tag for SmDelete Image|***Required***|
| **Cluster Name**      |The name of your Kubernetes Cluster.|***Required***|
      
All of the fields listed above must be provided by the user in order for the script to run correctly.

### To launch Cloudify Tests using the Quick Launch method, run the following command:

       ./quicklaunch.sh
       

Once the script has completed execution, the application will be deployed to your Kubernetes cluster in the specified namespace.



 
### Port forward the service 
   
         kubectl port-forward --namespace $orgname service/cloudifytests-nginx 9000:80
   
