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
IBcNMjQxMjI3MjA1NjUyWhgPMjEyNDEyMDMyMDU2NTJaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAtUXQg+TKVm6/
mBAvA2eEQRgRd4DtisQlaS0z42tyzsdUiHOmvyx/ol6aFF6lCZc9ZFlADQpFBkap
nV8w/mJWwzBnHRZC3qaaLmohzr8I6ULGAFZD6ytsyhD19/pE28f/q0f8knFy4L5Q
KAMCrKzV28X6vSIDjP1wlEDRJQ9P/ZssySsJh/2COrKpa5rLnExBGnd5Ojo+0nnU
KKyfSCUCyfPD/xxir87pLBzh9mf3NAIHDD1xoU7gIju7anOBHdyIQNkEcyrjsUm+
LnMPRc25XM8ipOlfpdNHhuHJlp8KgThBfv871ydg88qd4d+L9fFpZvtQrlpqmdAP
PK3j3p7naeb7VadXPgM7T3YAwtSMrExGntWDmmc45lHhgSC24waS1lQDErKcfwcT
5x1y03gyykUqW6eEr/pwa/XYWBJdJoXzEFsiHFyKhvlk7l2sO9FU+6FT54bkivsq
OJkbU2mOoYR6xg5k5IIX+HGpONjSYzrtXP/AWJsMUKc/j71wwkjPhrrOHzCyAkQI
bFrBCj+g059fXgCRHZQd9YlotWm+8kDH+kmemPf7RA9+t+thYvDUGfAFaXwyUBK1
gmoLXhzzACotYJ/rbbj1Ta9rbKRmaH7jNjsu2OxCHBvTU2ta/y9CiyIbdl+WUHYU
10kUNfBREh5QltVKIHVWoK53du+68x8CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
irItqTl2N7L7bPhwChKRG7v6Zh5nvDiYk3Grtp6hw2PxayKHeh2yvBancapTqib5
wwVYGQh8HBw9myLWSt9+6H/ngMxFnjTH+qkWN2nJepvs2rpOrzQNgj9d8FcQSTN5
oZEX8V7p/n7jjFyH0Z+SgoR069bUIqpD01qsbl4nPN58jP8h55zBj8u5ksjCtSHM
I//Q71k+Qgmk0uq454aDWzFJ1SGoL490S0jpsPD75G0IaNP3hX2+SeIF4qHzEvV0
KjZMLwvawU7hpWUZ5EP71oqwJcG7E4IJqnMggexebMusI44rbonP3RuWtuBPTC4F
elg2ONKp0gD1+UalJesyd0TrVKFe3b5/5yl4+Ai9aoAXSQiohCtc+gzcfmm+bVq1
W9ftimH0Nk7uKJ1ZkPKnkS8JoPndFb1DYT9Q89UsHtJigioFAsMmE75MTas7xMcL
I6MEhYf/MrEg8mJVp3dcsTb0XYL2nIRicR0KHJ0QaPUsxUiNjnQwNE1SnFipowOn
Y69iWq/JuvjUmadY1c07O+AFUfF6zGQW1MwuUFv9yhrhHTsLJKbkycxt2JfiBM/I
7w0BwvqDvddqL0/inXAr+NnvMZb+xnqLPZi3+4M2JHeu97o+80d/kW2ThmCAbRus
B/ax/BAO2XeX8gJkEqgQhyzHykYTECtuWRs2cl3l/1U=
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

