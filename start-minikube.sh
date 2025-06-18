#!/usr/bin/env bash
set -e  # Exit on error

# Start k8s env
if minikube status | grep -q "host: Running"; then
  echo "Minikube is already running."
else
  echo "Minikube is not running. Starting it now..."
  minikube start \
   --extra-config=kubelet.serialize-image-pulls=false
fi
eval $(minikube docker-env)

kubectl apply -f infrastructure/k8s/namespace.yaml