#!/usr/bin/env bash
set -euo pipefail

# Create local path for pv
JENKINS_HOME_DIR="/data/jenkins"
sudo mkdir -p "${JENKINS_HOME_DIR}"
echo "Prepared ${JENKINS_HOME_DIR}"

# Installation
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

helm repo add jenkins https://charts.jenkins.io
helm repo update

kubectl apply -f "$ROOT_DIR/../storage/storageclass.yaml"
kubectl apply -f "$ROOT_DIR/pv.yaml"
kubectl apply -f "$ROOT_DIR/pvc.yaml"

helm upgrade --install jenkins jenkins/jenkins \
    -f "$ROOT_DIR/helm-values.yaml"