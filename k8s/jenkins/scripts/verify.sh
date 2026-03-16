#!/usr/bin/env bash
set -euo pipefail

echo "[1/4] Checking pods..."
kubectl get pods -l app.kubernetes.io/name=jenkins

echo "[2/4] Checking PV/PVC..."
kubectl get pv jenkins-pv
kubectl get pvc jenkins-pvc

echo "[3/4] Checking Ingress..."
kubectl get ingress -l app.kubernetes.io/name=jenkins

echo "[4/4] Checking endpoint..."
curl -s -o /dev/null -w "HTTP %{http_code} - jenkins.mylab.local\n" http://jenkins.mylab.local || true

echo
echo "Done."
