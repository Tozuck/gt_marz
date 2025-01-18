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
apt install nload -y
apt install iftop -y

# Configure UFW (firewall)
echo_info "Configuring UFW..."
ufw allow 22  # SSH
ufw allow 80  # HTTP
ufw allow 443 # HTTPS
ufw allow 2053
ufw allow 2087
ufw allow 8080
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
IBcNMjUwMTE4MTM1OTQ3WhgPMjEyNDEyMjUxMzU5NDdaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyEuoo9r3Pf3K
ytZVIfSem7gWQLdyn9mxJASuZE+fubVc+Dr18xsHXFBPWI3BydKLYXKC/O6RE/eJ
9du63ZudCuqd5elYmvlSkXSQAKwVkU5q1Zfb6XeEggwiKGArSj2laKcwuk26DjzH
AX9KTMVQzUvDInGNY3wzpMUn/pSdNnSOdGXPH6MHCzCQpbSQLQ40Ep4AlrmNmc2Y
9qYQpRk1KTLT41vjOqCehu91yANAEe6/ObEokF/HRL/RIjkhnMqM7AA9lf/3hzv3
vZOLMO3ZylPvshK/G1VvxZS1MiLYTkJcgxpIq9hKCcrIs+UfKudaDy0GJJXUrMYZ
icXl46H/uWLMXcEjUcfLmv0UdsecIjNEvVLx48HkYOy0qL9yjt4yC3aA3eaeDGWz
Vr9wBArNtqDk2knjQe3wSYrhAYWrUGz0I+MPG16G3ekKRF5yz8N7TBUNdSYBCDat
6XU9OQvcwEXyhx5msdsQ3+snysCzOPFMJcfCoNmfQUAiYmyiuNbVXGMDk8UaFMTd
3ibOhtZpKuitVfE1C0R8K4M9bKwq4Q44SDBecLGZL3+0VVYm8A276PqfMdoutYpZ
/oLNJOQP3YpaS7Z3AxKmwrM0yB+QD/LGG9/aW9GturqlKLHZlcmxCrTnbDFhW01C
uxSo3n5HlEyshRDHqkqftzWAy5IzrOcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
JqsbAewY+ANHtyvRyHIASiPVtK4qhICqvVOiEzdnpOE0fK2a9mAZ17YHqlLtidBt
gWm6/3bFM/E+88u3TK8g+utMpkeZQVNnmgJECU2uB58U7j88ZtLS4j3OBq8ei1mU
gAnHyJhWCMYnairb0NKqDQMPJ0Hcf+OaOSbkiufsND78+J/Yk5wxh0ncp+69ulTe
8lAowmFfDBcgzyN+Es0sxPmfZ2eWrHO03HRIu/2J+MDKJowhpXqTDXqOPHXk32BC
ZdU2p5Ed6Hyqkf/Jl3TW1CdR886PZgGcOejCAMRLvnOBc1oJIYjTCdO3y6avsFuW
PpA01YaoDmb3ThzpQ7UO2g1oY6ZSYmmm7GkVlX4gnvqVms4juLgpdCe4qrWWgLfV
FoOFWA6t0WMY4wwyU/GK06q89EO9xO/x0FQO5fqb340LI/ZK95AV176vNfmpDaDW
atN0a3OHk4yIi4/gs/AWu5I9Nn718Fh2koivZBjNE/tn/BCotpsxu1sqKfgqiQmK
/p3fwhqrZQk6kBJnb3eCCW7makccOMb49L5+PnZLHVzbEmscysr0VNaqg4n1KUSQ
xLNR6WZXfsYR6QLW+asJ/QGH81mQl7o40yk4uFSNifL4/KfmjmiZ6GdOodEldMYR
MgpIas8oZU26Ag1jejhRbM+tRdpBbua/9JhiWA5UBjo=
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

