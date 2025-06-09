#!/usr/bin/env bash
set -e  # Exit on error

kubectl apply -f infrastructure/k8s/namespace.yaml

# Step 1: Apply Argo CD manifests
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# register the argocd-configuration to argocd

# Step 2: Wait for Argo CD components to be ready
echo "Waiting for Argo CD to become ready..."

kubectl wait deployment/argocd-server \
  --namespace argocd \
  --for=condition=Available \
  --timeout=300s

kubectl wait deployment/argocd-applicationset-controller \
  --namespace argocd \
  --for=condition=Available \
  --timeout=300s

# Step 3: Continue with other commands
echo "Argo CD is ready. Running follow-up commands..."

kubectl apply -f infrastructure/argocd/bootstrap.yaml

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

kubectl port-forward svc/argocd-server -n argocd 8080:443

#用户名：admin
#
#初始密码：kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d