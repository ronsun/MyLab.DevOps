#!/usr/bin/env bash
# Initialize the Kubernetes control-plane node.
# Scope: CONTROL PLANE ONLY
# Usage: bash 07.kubeadm-init.sh
set -euo pipefail

# Resolve the real (non-root) user even when invoked via "sudo bash".
REAL_USER="${SUDO_USER:-$(whoami)}"
REAL_HOME=$(eval echo "~${REAL_USER}")

# Flannel expects this CIDR for the pod network.
POD_NETWORK_CIDR="10.244.0.0/16"

echo "[1/5] Opening firewall port for kube-apiserver..."
sudo firewall-cmd --permanent --add-port=6443/tcp
sudo firewall-cmd --reload

echo "[2/5] Running kubeadm init..."
sudo kubeadm init --pod-network-cidr="${POD_NETWORK_CIDR}"

echo "[3/5] Setting up kubeconfig for ${REAL_USER}..."
mkdir -p "${REAL_HOME}/.kube"
sudo cp /etc/kubernetes/admin.conf "${REAL_HOME}/.kube/config"
sudo chown "$(id -u "${REAL_USER}"):$(id -g "${REAL_USER}")" "${REAL_HOME}/.kube/config"

echo "[4/5] Removing control-plane taint..."
# Single-node setup: allow workloads to be scheduled on the control-plane node,
# since there are no dedicated worker nodes.
sudo -u "${REAL_USER}" kubectl taint nodes --all node-role.kubernetes.io/control-plane-

echo "[5/5] Verifying cluster access..."
sudo -u "${REAL_USER}" kubectl get nodes
sudo -u "${REAL_USER}" kubectl cluster-info

echo
echo "Done."
