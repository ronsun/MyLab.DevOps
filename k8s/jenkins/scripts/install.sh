#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "[1/4] Preparing local storage directory..."
JENKINS_HOME_DIR="/data/jenkins"
sudo mkdir -p "${JENKINS_HOME_DIR}"
sudo chown 1000:1000 "${JENKINS_HOME_DIR}"

echo "[2/4] Adding Helm repo..."
helm repo add jenkins https://charts.jenkins.io
helm repo update

echo "[3/4] Applying storage resources..."
NODE_NAME=$(kubectl get nodes -o jsonpath='{.items[0].metadata.name}')
kubectl apply -f "$ROOT_DIR/../storage/storageclass.yaml"
sed "s/__NODE_NAME__/${NODE_NAME}/" "$ROOT_DIR/pv.yaml" | kubectl apply -f -
kubectl apply -f "$ROOT_DIR/pvc.yaml"

echo "[4/4] Installing Jenkins..."
helm upgrade --install jenkins jenkins/jenkins \
    -f "$ROOT_DIR/helm-values.yaml"