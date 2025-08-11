#!/bin/bash

sudo mkdir -p /etc/docker

cat <<'EOF' | sudo tee /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": { "max-size": "10m", "max-file": "3" },

  // Пул адресов для создаваемых overlay-сетей (чтобы не конфликтовали между узлами)
  "default-address-pools": [
    { "base": "10.20.0.0/16", "size": 24 }
  ],

  // Контейнерные veth уменьшаем по MTU, чтобы не упираться в MTU tailscale0 (~1280)
  // 1200 — безопасное значение (VXLAN + WireGuard дадут небольшой оверхед)
  "mtu": 1200,

  "live-restore": true,
  "iptables": true,
  "bridge": "none",
  "storage-driver": "overlay2"
}
EOF

sudo systemctl restart docker