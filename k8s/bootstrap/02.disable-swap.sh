#!/usr/bin/env bash
# Disable swap — required by kubelet.
# Scope: ALL NODES
# Usage: bash 02.disable-swap.sh
set -euo pipefail

echo "[1/3] Disabling active swap..."
sudo swapoff -a

echo "[2/3] Commenting out swap entries in /etc/fstab..."
sudo sed -i '/^[^#].*swap/s/^/#/' /etc/fstab

echo "[3/3] Verifying swap is off..."
swapon --show || true
free -h

echo
echo "Done."
