#!/usr/bin/env bash
set -e  # Exit on error

# Step 1: Apply Argo CD manifests
kubectl apply -f infrastructure/argocd-install
# register the argocd-configuration to argocd

# Step 2: Wait for Argo CD components to be ready
echo "Waiting for Argo CD to become ready..."

kubectl wait deployment/argocd-server \
  --namespace argocd \
  --for=condition=Available \
  --timeout=180s

kubectl wait deployment/argocd-application-controller \
  --namespace argocd \
  --for=condition=Available \
  --timeout=180s

# Step 3: Continue with other commands
echo "Argo CD is ready. Running follow-up commands..."
kubectl apply -f namespaces/namespaces.yaml
kubectl apply -f bootstrap.yaml

