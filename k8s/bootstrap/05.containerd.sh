#!/usr/bin/env bash
# Install containerd from Docker CE repo and configure it as the CRI for Kubernetes.
# Scope: ALL NODES
# Usage: bash 05.containerd.sh
set -euo pipefail

echo "[1/4] Adding Docker CE repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "[2/4] Installing containerd..."
sudo dnf install -y containerd.io

echo "[3/4] Generating containerd config with CRI enabled..."
# The containerd.io package ships with CRI disabled by default.
# Regenerate the config so the CRI plugin is active, then switch
# the cgroup driver to systemd (required by kubeadm).
sudo mkdir -p /etc/containerd
sudo containerd config default | sudo tee /etc/containerd/config.toml > /dev/null
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

echo "[4/4] Enabling and starting containerd..."
sudo systemctl enable --now containerd
containerd --version

echo
echo "Done."
