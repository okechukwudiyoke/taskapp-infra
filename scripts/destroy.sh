#!/bin/bash
set -e
echo "==> Destroying TaskApp infrastructure"
export KOPS_STATE_STORE="s3://taskapp-kops-state-292828418167"
echo "==> Deleting Kubernetes cluster..."
kops delete cluster --name taskapp.k8s.local --yes
echo "==> Destroying Terraform resources..."
cd terraform/
terraform destroy -auto-approve
cd ..
echo "==> Deleting S3 buckets..."
AWS_PROFILE=default aws s3 rb s3://taskapp-tf-state-292828418167 --force
AWS_PROFILE=default aws s3 rb s3://taskapp-kops-state-292828418167 --force
echo "==> All resources destroyed"
