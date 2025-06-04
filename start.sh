#!/usr/bin/env bash

minikube start
kubectl apply -f bootstrap.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443