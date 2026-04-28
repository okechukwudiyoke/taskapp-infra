# Runbook

## Deploy the Application
1. Run terraform apply in terraform/ directory
2. Run kops update cluster --yes --admin
3. Wait for kops validate cluster to show ready
4. Run scripts/install-addons.sh
5. kubectl apply -f k8s/app/

## Scale the Cluster
kubectl scale deployment backend --replicas=3 -n taskapp
kubectl scale deployment frontend --replicas=3 -n taskapp

## Rotate Database Password
1. Update postgres-secret.yaml with new password
2. kubectl apply -f k8s/app/postgres-secret.yaml
3. kubectl rollout restart deployment/backend -n taskapp

## Troubleshooting
- Pods not starting: kubectl describe pod <name> -n taskapp
- Certificate not issuing: kubectl describe certificate taskapp-tls -n taskapp
- DB connection errors: kubectl logs deployment/backend -n taskapp
- Cluster unhealthy: kops validate cluster

## Zero-Downtime Deployment
kubectl set image deployment/backend backend=<new-image> -n taskapp
kubectl rollout status deployment/backend -n taskapp

## Destroy Everything
Run ./scripts/destroy.sh from repo root
