#!/usr/bin/env bash
# Install base dependencies that later steps rely on.
# Scope: ALL NODES
# Usage: bash 01.prerequisites.sh
set -euo pipefail

TARGET_HOSTNAME="centos71"

PACKAGES=(
    openssl
    curl
    tar
)

echo "[1/3] Ensuring base packages: ${PACKAGES[*]}..."
sudo dnf install -y "${PACKAGES[@]}"

echo "[2/3] Setting persistent hostname to ${TARGET_HOSTNAME}..."
sudo hostnamectl set-hostname "${TARGET_HOSTNAME}"

echo "[3/3] Preventing cloud-init from overwriting hostname on reboot when present..."
if [[ -d "/etc/cloud/cloud.cfg.d" ]]; then
    printf 'preserve_hostname: true\n' | sudo tee /etc/cloud/cloud.cfg.d/99-preserve-hostname.cfg > /dev/null
else
    echo "cloud-init not detected; skipping preserve_hostname configuration."
fi

echo
echo "Current hostname:"
hostnamectl status

echo
echo "Done."
