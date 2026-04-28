# TaskApp Capstone Project

Cloud-native task management app deployed on AWS with Kubernetes.

## Live URLs
- Frontend: https://taskapp.okeydiyoke.com.ng
- Backend API: https://api.okeydiyoke.com.ng/api/health

## Stack
- Infrastructure: Terraform + Kops
- Kubernetes: 1.29.3, 3 masters + 3 workers across 3 AZs
- App: React frontend, Flask backend, PostgreSQL
- Ingress: NGINX with Let's Encrypt SSL
- Registry: AWS ECR

## Quickstart
1. Install: aws-cli, terraform, kops, kubectl, helm
2. Run: ./scripts/bootstrap.sh
3. Run: cd terraform && terraform apply
4. Run: ./scripts/create-cluster.sh
5. Wait for: kops validate cluster
6. Run: ./scripts/install-addons.sh
7. Run: kubectl apply -f k8s/app/

## Repository Structure
- terraform/ - VPC, IAM, DNS modules
- kops/ - Cluster specification
- k8s/app/ - Kubernetes manifests
- app/backend/ - Flask API + Dockerfile
- app/frontend/ - React app + Dockerfile
- docs/ - Architecture, runbook, cost analysis
- scripts/ - Automation scripts
