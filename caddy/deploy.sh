sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update -y
sudo apt install -y caddy python3-pip python3-flask npm unzip tmux 
$domain="lures.trusteddomain.com"
$caddy_config="$domain {
    {
    # Requests to https://example.com/api/* are reverse-proxied to your CORS service
    reverse_proxy /api/* localhost:8443

    # Requests to https://example.com/static/* are reverse-proxied to your Flask server
    reverse_proxy /static/* localhost:4443

    # Enable automatic HTTPS with HTTP challenge
    tls /home/azureuser/cert.pem /home/azureuser/certs/privkey.pem
    }
}

sudo echo $caddy_config > /etc/caddy/Caddyfile