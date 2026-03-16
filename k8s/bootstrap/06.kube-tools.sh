#!/usr/bin/env bash
# Install kubeadm, kubelet, kubectl, and Helm.
# Scope: ALL NODES
# Usage: bash 06.kube-tools.sh
set -euo pipefail

K8S_VERSION="v1.35"

echo "[1/5] Adding Kubernetes ${K8S_VERSION} repository..."
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/${K8S_VERSION}/rpm/repodata/repomd.xml.key
EOF

echo "[2/5] Installing kubeadm, kubelet, kubectl and dependencies..."
sudo dnf install -y kubelet kubeadm kubectl cri-tools iproute-tc container-selinux

echo "[3/5] Enabling kubelet..."
sudo systemctl enable --now kubelet

echo "[4/5] Installing Helm..."
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

echo "[5/5] Opening firewall port for kubelet API..."
sudo firewall-cmd --permanent --add-port=10250/tcp
sudo firewall-cmd --reload

echo
echo "Done."
