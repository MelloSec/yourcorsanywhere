#!/bin/bash
# Use sudo plz

# CONFIGURATION, EDIT PLEASE
# ALLOWED_DOMAINS=*
# ALLOWED_DOMAINS=https://localhost:5000
# CORS_DOMAIN=20.50.200.10 #(or domain name)

# Install dependencies
apt install npm -y

# Set up project
mkdir /opt
cd /opt
git clone https://github.com/mellosec/cors-anywhere.git
cd /opt/cors-anywhere
npm install

# changes that worked
# echo '#!/usr/bin/env node' | cat - /opt/cors-anywhere/server.js > temp && mv temp /opt/cors-anywhere/server.js
chmod +x /opt/cors-anywhere/server.js

# cd /opt
# git clone https://github.com/mellosec/yourcorsanywhere.git

# # Set up service
# cat <<EOT >> /etc/systemd/system/cors-anywhere.service
# [Unit]
# Description=CORS Anywhere Proxy

# [Service]
# ExecStart=/opt/cors-anywhere/server.js
# Restart=always
# User=nobody
# Group=nogroup
# Environment=PATH=/usr/bin:/usr/local/bin
# Install dependencies
# apt install npm

# # Set up project
# mkdir /opt
# cd /opt
# git clone https://github.com/mellosec/cors-anywhere.git
# cd /opt/cors-anywhere
# npm install

# changes that worked
# echo '#!/usr/bin/env node' | cat - /opt/cors-anywhere/server.js > temp && mv temp /opt/cors-anywhere/server.js
# chmod +x /opt/cors-anywhere/server.js # 
# Environment=PORT=8080 # uncommented use 8080 for Caddy, comment out to run direct

# For running as s service rather than TMUX
# Environment=CORSANYWHERE_WHITELIST=*
# WorkingDirectory=/opt/cors-anywhere
# [Install]
# WantedBy=multi-user.target
# EOT

# Caddy Steps

# Install Caddy
curl -o /usr/bin/caddy -s 'https://caddyserver.com/api/download?os=linux&arch=amd64'
chmod +x /usr/bin/caddy
groupadd --system caddy
useradd --system --gid caddy --create-home --home-dir /var/lib/caddy --shell /usr/sbin/nologin \
    --comment "Caddy web server" caddy

# Create Caddy service
curl -o /etc/systemd/system/caddy.service -s 'https://raw.githubusercontent.com/caddyserver/dist/master/init/caddy.service'

# Create Caddy configuration
CORS_DOMAIN=*
mkdir /etc/caddy
cat <<EOT >> /etc/caddy/Caddyfile
$CORS_DOMAIN:443 {
   reverse_proxy 127.0.0.1:8080
}

$CORS_DOMAIN:80 {
   reverse_proxy 127.0.0.1:8080
}
EOT

# Start Caddy
systemctl enable caddy
systemctl start caddy

# Forward from port 80 so you can run it as unprivileged user
# This is only necessary if you want to avoid caddy, but then you don't get HTTPS
#iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8080