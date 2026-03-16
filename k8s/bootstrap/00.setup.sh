#!/usr/bin/env bash
# One-click bootstrap for a Kubernetes control-plane node on CentOS Stream 10.
# Usage: bash 00.setup.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

STEPS=(
    "01.prerequisites.sh"
    "02.disable-swap.sh"
    "03.kernel-modules.sh"
    "04.sysctl-settings.sh"
    "05.containerd.sh"
    "06.kube-tools.sh"
    "07.kubeadm-init.sh"
)

for i in "${!STEPS[@]}"; do
    step="${STEPS[$i]}"
    echo ""
    echo "========================================"
    echo "  [$((i + 1))/${#STEPS[@]}] ${step}"
    echo "========================================"
    bash "${SCRIPT_DIR}/${step}"
done

echo ""
echo "========================================"
echo "  All done."
echo "========================================"
