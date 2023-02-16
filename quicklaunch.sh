#!/bin/bash

# Define the name of the namespace as input by the user
read -p "Enter the namespace name: " org_name

# Git clone the repository
sudo git clone  https://github.com/CloudifyLabs/cloudifytests_charts.git

# Change into the cloned repository directory
cd cloudifytests_charts

# Check if the operating system is Amazon Linux
if [[ "$(cat /etc/os-release | grep -o 'NAME=\"Amazon Linux\"')" == 'NAME="Amazon Linux"' ]]; then
  # Install openssl if it is not already installed
  if ! command -v openssl &> /dev/null; then
    sudo yum install -y openssl
  fi
fi

# Check if Helm is installed and install it if it's not
if ! command -v helm &> /dev/null; then
  curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash
fi

# Define the AWS access key and secret key as input by the user
read -p "Enter your AWS access key: " aws_key
read -p "Enter your AWS secret key: " aws_secret_key

# Define the base URL and ingress host as input by the user

read -p "Enter the ingress host: " ingress_host

# Define the AWS S3 bucket name and default region as input by the user
read -p "Enter your S3 bucket name: " s3_bucket
read -p "Enter your AWS default region: " aws_region

aws s3api create-bucket --bucket $s3_bucket --region=$aws_region

# Define the AWS ECR image repository and tag as input by the user
read -p "Enter your AWS ECR image repository: " ecr_repo
read -p "Enter the tag for sessionbe: " sessionbe_tag
read -p "Enter the tag for sessionui: " sessionui_tag
read -p "Enter the tag for smcreate: " smcreate_tag
read -p "Enter the tag for smdelete: " smdelete_tag
read -p "Enter your cluster name: " cluster_name

# Update KubeConfig
aws eks update-kubeconfig --name $cluster_name --region $aws_region


# Create a namespace with the name entered by the user
kubectl create namespace $org_name


helm repo add autoscaler https://kubernetes.github.io/autoscaler

helm install auto-scaler autoscaler/cluster-autoscaler --set  'autoDiscovery.clusterName'=$cluster_name \
--set awsRegion=$aws_region

kubectl apply -f ingress/deploy-tls-termination.yaml


# Apply the Helm chart using the inputs provided by the user
helm template . \
--set s3microservices.AWS_ACCESS_KEY_ID=$aws_key \
--set s3microservices.AWS_SECRET_ACCESS_KEY=$aws_secret_key \
--set urls.BASE_URL=http://cloudifytests-nginx.test.svc.cluster.local \
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
--set sessionmanager.AWS_ECR_IMAGE=public.ecr.aws/r2h8i7a4 \
--set smlogsvalues.ORG_NAME=$org_name \
--set behpa.metadata.namespace=$org_name --set sessionManagaerhpa.metadata.namespace=$org_name \
--set role.metadata.namespace=$org_name --set roleBinding.metadata.namespace=$org_name \
--set smcreatehpa.metadata.namespace=$org_name --set smdeletehpa.metadata.namespace=$org_name \
--set serviceaccount.metadata.namespace=$org_name \
--set roleBinding.subjects.namespace=$org_name | kubectl create --namespace $org_name -f -



# Get the hostname of the service in the specified namespace
hostname=""
for i in {1..5}; do
  hostname=$(kubectl get svc -n $org_name cloudifytests-nginx -o 'go-template={{range .status.loadBalancer.ingress}}{{.hostname}}{{end}}')
  if [[ -n "$hostname" ]]; then
    break
  else
    echo "Hostname not found. Retrying in 30 seconds..."
    sleep 30
  fi
done

if [[ -z "$hostname" ]]; then
  echo "Failed to get the hostname."
  exit 1
fi

echo "The hostname of service is: $hostname"
