#!/usr/bin/env bash

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm upgrade --install loki grafana/loki \
  --namespace=observability \
  --set deploymentMode=SingleBinary \
  --set singleBinary.replicas=1 \
  --set read.replicas=0 \
  --set write.replicas=0 \
  --set backend.replicas=0 \
  --set gateway.enabled=false \
  --set loki.auth_enabled=false \
  --set loki.storage.type=filesystem \
  --set loki.storage.filesystem.directory=/data/loki \
  --set persistence.enabled=true \
  --set persistence.size=5Gi \
  --set loki.useTestSchema=true