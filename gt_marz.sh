#!/bin/bash

set -e  # Exit on any error

# Function to log and print messages
echo_info() {
  echo -e "\033[1;32m[INFO]\033[0m $1"
}
echo_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $1"
  exit 1
}

# Check for root privileges
if [ "$EUID" -ne 0 ]; then
  echo_error "This script must be run as root. Use sudo."
fi

# Update system packages
echo_info "Updating package lists..."
apt-get update

# Install required packages
echo_info "Installing required packages..."
apt-get install -y curl socat git ufw || echo_error "Failed to install packages."

# Configure UFW (firewall)
echo_info "Configuring UFW..."
ufw allow 22  # SSH
ufw allow 80  # HTTP
ufw allow 443 # HTTPS
ufw allow 62050
ufw allow 62051

# Install Docker
echo_info "Installing Docker..."
if ! command -v docker &> /dev/null; then
  curl -fsSL https://get.docker.com | sh || echo_error "Docker installation failed."
else
  echo_info "Docker is already installed."
fi

# Clone Marzban Node repository
echo_info "Cloning Marzban Node repository..."
if [ ! -d "~/Marzban-node" ]; then
  git clone https://github.com/Gozargah/Marzban-node ~/Marzban-node || echo_error "Failed to clone Marzban Node repository."
else
  echo_info "Marzban Node repository already exists."
fi

# Create necessary directories
echo_info "Creating necessary directories..."
mkdir -p /var/lib/marzban-node

# Generate Docker Compose configuration
echo_info "Creating Docker Compose configuration..."
cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host
    environment:
      SSL_CERT_FILE: "/var/lib/marzban-node/ssl_cert.pem"
      SSL_KEY_FILE: "/var/lib/marzban-node/ssl_key.pem"
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"
    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL

# Generate placeholder SSL certificate
echo_info "Creating placeholder SSL certificate..."
cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjQwNjIzMTQyMDQ4WhgPMjEyNDA1MzAxNDIwNDhaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAvih1mAlsSQgI
2J6ZJOPG/uOpyBJhk+nYmHmUSxu81kFDsCtTbGj+ykd/00j7hKfG5KUOyZkp4bSg
ivZWlRIKsCEwvpuHpo1uxwHRX18JImozffBB8gKwfJHbItEw+0xjFSFIY3heLzfk
tzS3VUxw/Yi9ZcE/o7wGH/P4PZyyHQgcs4/l2bNQ87gHRvOXo0IlXjbRUmbOXiT7
KK3jYOWJmzT4ULM0g6NNi5qwlSHEZ9wMbuKnxao1e+9JD9tqR0i9UlLS0qyzDu+z
ck/tse5CY7qjHFEmfYUAV8F0yTU4EaOkwsUwpK0Uti0zvxL8An9zJTEjUdnYMis2
bBBN6hOyUeUNoel4kg2HtTb6uYXkOwsDjeDTnke++z5q9PfGJtNmc3LMksbFc069
mx78a8BP/u9aEe1GLQoQz0nmkOpxXXVFz+2Osn6XQbepyY12Uin2jzapERqOSFxP
YQuHznh6fVhnWmD5IteE6GefUYN7GVYTDj19G4tC5BBDKxGcqu6w2GRg/8zZ791f
Ux2UYNNrb5wV1PQ7eo7cYn/vccfCk0Feaq3B0ISiXnYdbbD1SWVr9Smh3wK8RMPK
0gf/w/D0i+BcojTr6PKi6dl+dpgE3DrMRdsp+Q2bQnOHKn73oOaS2vL7Ovnqqnyj
AvA4fMI37/D6YC3rBYuCBEO8CIqeWYMCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
VAx+0yr/sDdu/sfaKghxoggmkp6NpoCb8uzrSrHpOTL0xAmyUYzggYjYqmMGQoc+
kklRsgorKPHqTzZv1a3/GFgtL3z/15qo624r46hTk2iM6fE0+VVksUDD3pisLT6K
FbXx5LzsDupgHSp9kJtPjigj4TBJwgmXTDKTkpY998dqvVVrlJMDuJ9mru8iTuBR
8dLvhPl/LRZw71vPSNDbgCLT/+3vx+PhYl6kPbYST+OUnQtpzSrefD8tV3wYScze
TNmLrtK8mxWO7smXmVcfOacFvO6lDj0eBxvjKovug9ZFShLL5bztX4DYVZeDYCVZ
qtnVfE4akaB4BoUZsDB0V2cA8nnif8Dk4FktWEFhj+ZIt/+b8MNLZPqwrbzpqMNH
eIzwrBA8KtVzPuj4upNQaW9TGy92FeBf1yR+nPGrEhnZMbv4n4AWRwdLtkHmi86u
LbAguAXkHGsSgwaar2ipmGqjlMDwhCpIrcR2GvVi4lY54ARnHiOQ2RBODo0mDLDz
hAVJJCgvHOlxuGgz2lDd+vOW0GYdE7Wj30aIT7GDLO28aObKgGYrXQOSOzrqt+GY
065dnL788942Y965n+tV51wdfR2UOBGvVaBva4fnfUZS/SKDMK9yR03omTDN51kB
ZKuDULjL23UUbAP5l+/obg1NbzhTg2y0dbkU08yl4Dc=
-----END CERTIFICATE-----
EOL

# Start the Marzban Node service
echo_info "Starting Marzban Node service..."
cd ~/Marzban-node
docker compose up -d || echo_error "Failed to start Marzban Node service."

# Enable and reload UFW
echo_info "Finalizing UFW setup..."
ufw --force enable
ufw reload

# Clear shell history for security
echo_info "Clearing shell history..."
history -c

# Sleep for 3 seconds before closing the connection
echo_info "Setup complete. Marzban Node is now running. Closing connection in 3 seconds..."
touch /tmp/gt_marz_installed_complete
sleep 3
exit 0
