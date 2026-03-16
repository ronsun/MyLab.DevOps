#!/usr/bin/env bash
set -euo pipefail

echo "Jenkins admin credentials:"
echo "  User: admin"
echo -n "  Pass: "
kubectl get secret jenkins -o jsonpath='{.data.jenkins-admin-password}' | base64 -d
echo
