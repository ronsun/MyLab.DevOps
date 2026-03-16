#!/usr/bin/env bash
# Install base dependencies that later steps rely on.
# Scope: ALL NODES
# Usage: bash 01.prerequisites.sh
set -euo pipefail

PACKAGES=(
    openssl
    curl
    tar
)

echo "[1/1] Ensuring base packages: ${PACKAGES[*]}..."
sudo dnf install -y "${PACKAGES[@]}"

echo
echo "Done."
