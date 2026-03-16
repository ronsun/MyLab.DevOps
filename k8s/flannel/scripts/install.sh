#!/usr/bin/env bash
set -euo pipefail

echo "[1/3] Opening firewall port for Flannel VXLAN..."
sudo firewall-cmd --permanent --add-port=8472/udp
sudo firewall-cmd --reload

echo "[2/2] Applying Flannel manifest..."
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml

echo
echo "Done."
