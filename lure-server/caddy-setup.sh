#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install caddy -y
mv /etc/caddy/Caddyfile /etc/caddy/working.Caddyfile && cp ~/yourcorsanywhere/lure-server/Caddyfile /etc/caddy/Caddyfile
sudo systemctl reload caddy


