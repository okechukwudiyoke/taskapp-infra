# Architecture Document

## Overview
TaskApp deployed on AWS using Kops, Terraform, and modern DevOps practices.

## Components
- Frontend: React SPA, 2 replicas
- Backend: Flask API, 2 replicas, 526Mi memory limit
- Database: PostgreSQL StatefulSet, EBS-backed persistent storage
- Cluster: Kubernetes 1.29.3 managed by Kops

## Network
- VPC: 10.0.0.0/16 across eu-north-1a, eu-north-1b, eu-north-1c
- 3 public subnets for NAT Gateways and Load Balancers
- 3 private subnets for all Kubernetes nodes
- 3 NAT Gateways for HA outbound internet

## High Availability
- 3 control plane nodes across 3 AZs, etcd survives 1 master loss
- 3 worker nodes across 3 AZs
- 2 replicas for frontend and backend with rolling updates

## Security
- All nodes in private subnets, no public IPs
- Separate IAM roles for masters and workers
- Secrets stored as Kubernetes Secrets
- SSL via Let's Encrypt and cert-manager
- Encrypted EBS gp3 volumes

## Traffic Flow
User -> Route53 -> NLB -> NGINX Ingress -> Frontend/Backend Services -> PostgreSQL
