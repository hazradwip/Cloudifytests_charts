# cloudifytests Infrastructure


This document provides the steps for installing the Cloudifytests product from AWS Marketplace.

## Prerequisite
**kubectl –** A command line tool for working with Kubernetes clusters.
### Install Kubectl
[Install Kubectl in your local](https://kubernetes.io/docs/tasks/tools/)

**eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.
### Install Eksctl
[Install eksctl in your local](https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html)

Minimum requirements to run application on the cluster:-

   You need 4vCPU machine and 4gb ram
   
## Or you can use eksctl to create a cluster. (Optional)
### Configure AWS Cli using your <Access Key> & <Secret Access Key>

  
apiVersion: eksctl.io/v1alpha5
kind: ClusterConfig
metadata:
  name: stg-cloudifytests
  region: us-east-1
  version: "1.22"
nodeGroups:
  - name: browsersession
    instanceType: c5.large
    minSize: 1
    maxSize: 4
    desiredCapacity: 1
    volumeType: gp3
    volumeSize: 50
    kubeletExtraConfig:
        kubeReserved:
            cpu: "200m"
            memory: "200Mi"
            ephemeral-storage: "1Gi"
        kubeReservedCgroup: "/kube-reserved"
        systemReserved:
            cpu: "200m"
            memory: "300Mi"
            ephemeral-storage: "1Gi"
        evictionHard:
            memory.available:  "100Mi"
            nodefs.available: "10%"
        featureGates:
            RotateKubeletServerCertificate: true
    ssh:
      allow: true
      publicKeyName: "cloudifytests"
    
    ------You can use taints for nodes as well or keep as it is (optional)-----

    taints:
      browsersession: "true:NoSchedule"
    labels: {role: worker}
    tags:
      nodegroup-role: worker
    iam:
      withAddonPolicies:
        externalDNS: true
        certManager: true
        imageBuilder: true
        autoScaler: true
        appMesh: true
        appMeshPreview: true
        ebs: true
        efs: true
        albIngress: true
        xRay: true
        cloudWatch: true
  - name: userapp
    instanceType: t3.xlarge
    minSize: 1
    maxSize: 4
    desiredCapacity: 1
    volumeType: gp3
    volumeSize: 50
    kubeletExtraConfig:
        kubeReserved:
            cpu: "200m"
            memory: "200Mi"
            ephemeral-storage: "1Gi"
        kubeReservedCgroup: "/kube-reserved"
        systemReserved:
            cpu: "200m"
            memory: "300Mi"
            ephemeral-storage: "1Gi"
        evictionHard:
            memory.available:  "100Mi"
            nodefs.available: "10%"
        featureGates:
            RotateKubeletServerCertificate: true
    ssh:
      allow: true
      publicKeyName: "cloudifytests"

    ------You can use taints for nodes as well or keep as it is (optional)--------- 
    
    taints:
      userapp: "true:NoSchedule"
    labels: {role: worker}
    tags:
      nodegroup-role: worker
    iam:
      withAddonPolicies:
        externalDNS: true
        certManager: true
        imageBuilder: true
        autoScaler: true
        appMesh: true
        appMeshPreview: true
        ebs: true
        efs: true
        albIngress: true
        xRay: true
        cloudWatch: true
   


### Steps to add infrastructure to your local

Git clone the project:

       $ git clone https://github.com/CloudifyLabs/cloudifytests_charts.git
       
  
### Create a Namespace (namespace name is uesd as $org_name)
   
### Create a service to expose the application

   
apiVersion: v1
kind: Service
metadata:
  name: nginx-cloudify-node-port
spec:
  type: NodePort
  selector:
    app: cloudifytests-nginx
  ports:
      # By default and for convenience, the targetPort is set to the same value as the port field.
    - port: 80
      targetPort: 80
      # Optional field
      # By default and for convenience, the Kubernetes control plane will allocate a port from a range (default: 30000-32767)
      nodePort: 30005

### Apply helm using following command:

        $  helm template . \
        --set s3microservices.AWS_KEY=<YOUR_AWS_ACCESS_KEY> \
        --set s3microservices.AWS_SECRET_KEY=<YOUR_AWS_SECRET_KEY> \
        --set urls.BASE_URL=http://nginx-cloudify-node-port.$orgname.svc.cluster.local \
        --set s3microservices.AWS_BUCKET=<Your_S3_BUCKET_NAME>  \
        --set s3microservices.AWS_DEFAULT_REGION="<Your_AWS_REGION_NAME>" \
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
   
   kubectl port-forward --namespace $orgname service/nginx-cloudify-node-port 9000:80
   
