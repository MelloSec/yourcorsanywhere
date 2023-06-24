sudo caddy reload --config /etc/caddy/Caddyfile

sudo caddy reload --config home/ansible/yourcorsanywhere/caddy/Caddyfile
sudo caddy reload --config home/ansible/yourcorsanywhere/caddy/Caddyfile2
sudo caddy reload --config home/ansible/yourcorsanywhere/caddy/CORS-Caddyfile
sudo caddy reload --config home/ansible/yourcorsanywhere/caddy/CONENT-Caddyfile

sudo systemctl start caddy
# Let caddy own the private key
sudo chown caddy:caddy /home/ansible/certs/privkey.pem


