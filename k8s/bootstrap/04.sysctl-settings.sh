#!/usr/bin/env bash
# Set kernel parameters for bridge networking and IP forwarding.
# Scope: ALL NODES
# Usage: bash 04.sysctl-settings.sh
set -euo pipefail

echo "[1/2] Writing sysctl config..."
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

echo "[2/2] Applying sysctl parameters..."
sudo sysctl --system

echo
echo "Done."
