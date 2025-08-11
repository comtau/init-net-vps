#!/bin/bash

sudo apt-get update -y
sudo apt-get install -y curl ca-certificates gnupg lsb-release net-tools htop jq ufw

cat <<'EOF' | sudo tee /etc/modules-load.d/docker-overlay.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<'EOF' | sudo tee /etc/sysctl.d/99-docker.conf
net.bridge.bridge-nf-call-iptables=1
net.ipv4.ip_forward=1
EOF

sudo sysctl --system

curl -fsSL https://tailscale.com/install.sh | sh

sudo tailscale up --ssh

tailscale ip -4