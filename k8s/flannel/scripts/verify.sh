#!/usr/bin/env bash
set -euo pipefail

echo "[1/2] Checking Flannel pods..."
kubectl get pods -n kube-flannel

echo "[2/2] Checking node status..."
kubectl get nodes

echo
echo "Done."
