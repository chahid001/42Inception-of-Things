#! /bin/bash

#export K3S VAR
export K3S_NODE_NAME=schahidSW
export INSTALL_K3S_EXEC="--flannel-iface=eth1"
export K3S_URL=https://$1:6443
export K3S_TOKEN=$(sudo cat /scha/token)
export K3S_KUBECONFIG_MODE="644"
#install K3S
echo "Installing K3s agent......"
curl -sfL https://get.k3s.io | sh -