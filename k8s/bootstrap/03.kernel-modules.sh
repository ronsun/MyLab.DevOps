#!/usr/bin/env bash
# Load kernel modules required by containerd and kube-proxy.
# Scope: ALL NODES
# Usage: bash 03.kernel-modules.sh
set -euo pipefail

echo "[1/3] Persisting module config..."
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

echo "[2/3] Loading modules into running kernel..."
sudo modprobe overlay
sudo modprobe br_netfilter

echo "[3/3] Verifying..."
lsmod | grep -E 'overlay|br_netfilter'

echo
echo "Done."
