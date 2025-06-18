#!/usr/bin/env bash

# Install Prometheus stack
echo "Install prometheus stack"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack -n observability