#!/bin/bash
user="ec2-user"
domain=""
certs="~/certs"
lure="~/yourcorsanywhere/lure-server/dynamic-lures"
cors="~/yourcorsanywhere/lure-server/cors-anywhere"

# Dependencies
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update -y
sudo apt install -y python3-pip python3-flask npm unzip tmux
pip3 install updog 

# Folders and Repos
cd ~
mkdir $certs
git clone --recurse-submodules https://github.com/mellosec/yourcorsanywhere 



# # SSL Shenanigans
# # //////////////////////// We need to figure out timing, we need this VMs IP address to set the A record needed for challenge
# echo "Script will pause so you can set DNS A record for the IP Address of this machine."
# echo "If you don't do this certbot will fail!"
# read -p "Press Enter to continue..."



# # certbot for LetsEncrypt certificate
# sudo certbot certonly --register-unsafely-without-email -d $domain --standalone --preferred-challenges http --non-interactive --agree-tos
# sudo ls /etc/letsencrypt/live/$domain/
# sudo cp /etc/letsencrypt/live/$domain/cert.pem $certs
# sudo cp /etc/letsencrypt/live/$domain/chain.pem $certs
# sudo cp /etc/letsencrypt/live/$domain/privkey.pem $certs
# sudo cp /etc/letsencrypt/live/$domain/fullchain.pem $certs

# # Backend Services before Proxy
# # CORS - Start in detached session 
# tmux new-session -d -s cors
# tmux send-keys -t cors "cd /home/$user/yourcorsanywhere/lure-server/cors-anywhere" Enter
# tmux send-keys -t cors "npm install" Enter
# tmux send-keys -t cors "node lure-server.js" Enter

# # Updog -  Start in detached session 
# tmux new-session -d -s updog
# tmux send-keys -t updog "cd /home/$user/yourcorsanywhere/dynamic-lures" Enter
# tmux send-keys -t updog "updog -p 5000 --ssl" Enter

# # Caddy - Configure and restart reverse-proxy
# # Change owndership of cert to Caddy 
# sudo chown caddy:caddy $certs/privkey.pem

# # Backup old Caddyfile and  move your copy that you placed in the repositoy at /yourcorsanywhere/caddy/Caddyfile
# # /////////////////// YOU MUST CHANGE DOMAIN TO YOURS UP ABOVE AND IN THE CADDYFILE AT THIS LOCATION AS WELL ///////////////////////
# sudo mv /etc/caddy/Caddyfile /etc/caddy/working.Caddyfile && sudo cp ~/yourcorsanywhere/caddy/Caddyfile /etc/caddy/Caddyfile
# sudo systemctl restart caddy
# sudo systemctl status caddy

