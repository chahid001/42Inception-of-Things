#! /bin/bash

export K3S_NODE_NAME=schahidS
export INSTALL_K3S_EXEC="--bind-address=$1 --flannel-iface=eth1"
export K3S_KUBECONFIG_MODE="644"
echo "Installing K3s server....."
curl -sfL https://get.k3s.io | sh -s

i=1

while [ $i -le 3 ]
do 
    kubectl apply -f /schahid/App-$i/app.deployment.yaml
    kubectl apply -f /schahid/App-$i/app.service.yaml
    i=$((i + 1))
done

kubectl apply -f /schahid/app.ingress.yaml