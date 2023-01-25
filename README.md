# cloudifytests Infrastructure


## Prerequisite
**kubectl –** A command line tool for working with Kubernetes clusters.

**eksctl –** A command line tool for working with EKS clusters that automates many individual tasks.



## Steps to add infrastructure to your local

Git clone the project:

       $ git clone https://github.com/Roshanitft/cloudifytests.git
       
To patch the core-dns deployment with taints and tolleration use the following command.

        $ kubectl patch deployment coredns -p \
        '{"spec":{"template":{"spec":{"tolerations":[{"effect":"NoSchedule","key":"userapp","value":"true"}]}}}}' -n kube-system
        
        
Add ingress-controller to your cluster using ingress.yaml file. Use your SSL cert ARN on line number 275.

   $ kubect apply -f ingress/ingress.yaml
   
   
   
Add metrics server to your cluster using metrics-server/deployment.yaml file.

   $ kubectl apply -f metrics-server/deployment.yaml
   
 
Create a Namespace (namespace name is uesd as $org_name)


Apply helm using following command:

        $  helm template . \
        --set s3microservices.AWS_KEY=<YOUR_AWS_ACCESS_KEY> \
        --set s3microservices.AWS_SECRET_KEY=<YOUR_AWS_SECRET_KEY> \
        --set urls.BASE_URL=https://$org_name.cloudifytests.io \
        --set s3microservices.AWS_BUCKET=<Your_S3_BUCKET_NAME>  \
        --set s3microservices.AWS_DEFAULT_REGION="<Your_AWS_REGION_NAME>"
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
        
