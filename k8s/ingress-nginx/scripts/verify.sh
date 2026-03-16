#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Checking pods..."
kubectl get pods -l app.kubernetes.io/name=ingress-nginx

echo "[2/3] Checking IngressClass..."
kubectl get ingressclass

echo "[3/3] Checking host ports 80/443..."
sudo ss -tlnp | grep -E ':80|:443'

echo
echo "Done."
