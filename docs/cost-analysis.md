# Cost Analysis

## Monthly Estimate (eu-north-1)

| Resource | Count | Unit Cost | Monthly |
|---|---|---|---|
| t3.medium (masters) | 3 | $0.0416/hr | $90 |
| t3.large (workers) | 3 | $0.0832/hr | $180 |
| NAT Gateway | 3 | $0.048/hr | $105 |
| EBS gp3 (etcd, 20GB x6) | 6 | $0.10/GB | $12 |
| EBS gp3 (nodes, 80GB x6) | 6 | $0.10/GB | $48 |
| EBS gp3 (postgres, 10GB) | 1 | $0.10/GB | $1 |
| Network Load Balancer | 1 | $0.025/hr | $18 |
| S3 (state + backups) | - | ~$1 | $1 |
| Route53 | 1 zone | $0.50/zone | $1 |
| ECR | 2 repos | ~$0.50 | $1 |
| **Total** | | | **~$457/month** |

## Cost Optimisation Opportunities
- Use spot instances for workers: saves up to 70%
- Single NAT Gateway for dev: saves $70/month
- Scale down masters to t3.small: saves $45/month
- Reserved instances for 1-year term: saves 30-40%

## Budget Alert
AWS budget alert set at $50 for this project duration.
Cleanup script provided to destroy all resources after submission.
