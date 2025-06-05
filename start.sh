#!/usr/bin/env bash
set -e  # Exit on error

# Step 1: Apply Argo CD manifests
kubectl apply -k infrastructure/argocd-install
# register the argocd-configuration to argocd

# Step 2: Wait for Argo CD components to be ready
echo "Waiting for Argo CD to become ready..."

kubectl wait deployment/argocd-server \
  --namespace argocd \
  --for=condition=Available \
  --timeout=180s

# Step 3: Continue with other commands
echo "Argo CD is ready. Running follow-up commands..."
kubectl apply -f infrastructure/namespaces/namespace.yaml
kubectl apply -f bootstrap.yaml

kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d

kubectl port-forward svc/argocd-server -n argocd 8080:443

#用户名：admin
#
#初始密码：kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d