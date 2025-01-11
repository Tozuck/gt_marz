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
ufw allow 2053
ufw allow 2087
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
IBcNMjUwMTExMDcyNDM5WhgPMjEyNDEyMTgwNzI0MzlaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAunMbJ1PqCSQU
tcqVkKTy6n++Lc+zWRonJnwNViVO8s+nHiEAB2rSbcOe6IMf094kOHVsS/HJqoRV
L7F5FWMvEqD9hAHaNkwTChASqKsBwMe+yuoK5OCStZ6hizV9jMnIXkVW80wfl8lQ
2zbEoh8BsdJqOdATNOJ2luXofn2fkp1X7rtD1HLRSjJXWU2WgGkAFRkqyYJRX7nC
0FCKUKeOsvEMMaq1piO9jIfjWRXdoVcGkTwJ/N2LMa9YS9RIkGTkHO3W0NYOgvWv
LqWnLaH4LIXZM2DLOe+FnPzvdE4ZMbWHCdWGlYrkvkg/DKAfaddGX1obzpnxJ0yw
qcGxx7ZEs2ohukk3TLGLKj5A2pkRT0haPfw/DdCIFNRCI7avpvtwFHM/WAzV4N+I
vQE1cduAmDIBpuSzpexCbcQRGBSVIY5upd2nnFRLFnD590NWtBu/C6wTyZnIgqXp
XVcH74UI4Lossx06WddOHHCS+5mU4wroRxRNuKjqJjhMDAltX9i06t1lVEf5AGHr
6oDe1+R3EydtxXZOCRdvNDyM0yPZRJmkvXDqcoe8G9gJHXyJ5cvaZFvya1r0ageb
7WrjHYeoomDCwP3d8uRSd61ftbVcOVUkx6glDr2pwlDaVmeWMuqj9plMdTJAJIcG
SpExN4tZBXOudRFu7Jo8KuadzJaUPZcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
esfy8qy86vqJdASGjReE7rQnOCPmN/2JtsXM51BheLpbuGUt/iF/1vNV6xlbh67M
HKZTVL6IOf0CXH8w1FtEY5tI9vbVvxTbk0i6Fr16bTyqeBromDfAw1mb+MmZW4R1
WL+UZ5CsCpR57gnqYs+kpRiCFomLAPgr/+W5+KC0+As3l808r4XOK7NwgiQ3/tLA
8Fyw9iSJTme+/vOcby6N1Kph7mafLba3QCpPVs79xUloTYTaArD0QCqeIqcz9j3n
AeUDaC4Upd6isSw1BYDtRLlKer0owQyETqOrod6uaogRHnqJSQNJga2hUZz2md+6
xL2HLqhJ4MARqoGwt0QkRP7yPAB9XfIXF3MxJDFjBB2K/7ERPCy+Q4YkmnPs+uWi
4fBL9BnvtpHYy+xsWhF/sOuERdqz86tCul/Yy5KnSiYTLbEDJyWJodNTkIVL6l+w
3QUwPXrmAeXeU8dxwUOtPkbmTSi/hb5J73bdjDb9mcU3mmXFR0LpSDRRweTKJ9ss
esFdUpmSldtGivI5KvlOnduw9egDxafrQZjFFLesDyj/XdD9C5/wrqNINaMmSFli
6gJWXtInN/qvdyH2mFWhp9xLSTpudqpYl5zV5NsG2uMGvhI9gqUGeE+sO+n+gM2J
MaAspdhdVgGp4XczcExsnYhv7Jq4IUZGZ1kL8cyOZ7I=
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

