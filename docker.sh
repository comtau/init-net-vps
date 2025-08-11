#!/bin/bash

sudo mkdir -p /etc/docker

cat <<'EOF' | sudo tee /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "3" },
  "default-address-pools": [
    { "base": "10.20.0.0/16", "size": 24 }
  ],
  "mtu": 1200,
  "iptables": true,
  "bridge": "none",
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker