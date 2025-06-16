#!/usr/bin/env bash
set -e  # Exit on error

# Start k8s env
if minikube status | grep -q "host: Running"; then
  echo "Minikube is already running."
else
  echo "Minikube is not running. Starting it now..."
  minikube start
fi
eval $(minikube docker-env)

# Create the necessary namespaces
kubectl apply -f infrastructure/k8s/namespace.yaml

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Waiting for Argo CD to become ready..."

# Waiting ArgoCD startup, this step may spend a long time
kubectl wait deployment/argocd-server \
  --namespace argocd \
  --for=condition=Available \
  --timeout=300s

kubectl wait deployment/argocd-applicationset-controller \
  --namespace argocd \
  --for=condition=Available \
  --timeout=300s

echo "Argo CD is ready. Running follow-up commands..."

# Register argoCD projects
# Install observability: Prometheus/AlertManager/Grafana/Loki/OTEL/Tempo
# Install application: my-kotlin-app
kubectl apply -f infrastructure/argocd/bootstrap.yaml

# Port forward for argoCD
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "argoCD username: admin"
echo "argoCD password: $(kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d)"