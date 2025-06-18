#!/usr/bin/env bash

echo "Install opentelemetry"
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts

# Install the Operator
helm install opentelemetry-operator open-telemetry/opentelemetry-operator \
  --namespace observability