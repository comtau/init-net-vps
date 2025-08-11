#!/bin/bash

sudo ufw default deny incoming
sudo ufw default allow outgoing

# Разрешаем трафик внутри tailnet:
sudo ufw allow in on tailscale0
sudo ufw allow out on tailscale0

# Разрешим SSH только через Tailscale-SSH (порт 22 локально можно закрыть, если хочешь):
sudo ufw deny in on eth0 to any port 22

# Swarm-порты блокируем на внешнем интерфейсе (чтобы межузловая связь шла ТОЛЬКО по tailscale0):
sudo ufw deny in on eth0 to any port 2377 proto tcp   # swarm control-plane
sudo ufw deny in on eth0 to any port 7946 proto tcp   # gossip TCP
sudo ufw deny in on eth0 to any port 7946 proto udp   # gossip UDP
sudo ufw deny in on eth0 to any port 4789 proto udp   # VXLAN (overlay data)

# Включаем форвардинг (для докера):
sudo sed -i 's/^DEFAULT_FORWARD_POLICY=.*/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

sudo ufw enable
sudo ufw status verbose