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
apt-get install -y curl socat git ufw iptables-persistent || echo_error "Failed to install packages."

# Configure UFW (firewall)
echo_info "Configuring UFW..."
ufw allow 22  # SSH
ufw allow 80  # HTTP
ufw allow 443 # HTTPS
ufw allow 62050
ufw allow 62051
ufw deny in proto icmp

iptables -A INPUT -p icmp --icmp-type echo-request -j DROP


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
IBcNMjQxMDI4MjA0MzQ5WhgPMjEyNDEwMDQyMDQzNDlaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAsnKzvHaUGoIN
baono/8D6qiJ0Ref+b+ZFNJYWGtpxzu9wuLmIM9t5pa3P+iC52o5+nn3dFbslDjX
a0tmr7rGiW/eNjScFrN6xBKG+H3gOHu9PXa02Jm74AbR1s2qm08bDYJuaerR/9Ww
Q71318kmLD2GSk9WpOSkBN1GjN5MObUikL+uEK1q2EznCEdcFfbJOoU6UuZwrL2R
xJdDn6U4uoH4r7+i028G9b5TDld5uj+1+DXlzktTU/HCPz6CIfQUS+ZKYW93xrwk
9+ZraXIC386I36WXPr9V2UdwAXhXD/NtNPBkoozeZ+Dsb2mgQh11fySymaSjeJ/E
5JzYyBG9kHNtuxwhaDnB77afClOaRUbBczA84T9RZMatTUyw2ofpw6lFHPa9Z3lt
bzSuoV6vdyXbSDFAWsDPbQvmbr+WZFJhayJn4pNkz/IqK7ma2DnvRtb0koYg508d
s6o/N6e0Gp98VN2objhrDt9PkMj/khZ2XvbPZ4uLPpzIeeeoyOT3UogQnloSdBkO
RpINEgVJKUaKphcQZTjeUFJWOxaglAgOWGw22Mj7M2fh1PeyrYPAFFamaqxDsE6b
WbLnIBsp0g95lbFiSJHQpOs9zakXlnW7sHa5RGSQKreqI/hVxxirlGFPZ9fc2mBe
QKhK/R9Yv99BEdmaust2yg9qkqyxbwcCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
dp05H45ZHG5ZEGjsM9b6bd4jxE7dsszs2tBZo0htO7Pp/RMQDfMp5RZpoX6Cer8Y
k5+IvZgAsvCZ6AGeiTj4RaYQxxVx/+tgBc968kGlbsi3GmzyggQv7fNbRqrQN3EM
BJEzWljb5FzWbzQglH7NhditgUzTTRsvY733n1o9wVbke2rL0Jn4MBrTVhSNojYB
SQ8HFFvodKDO6KaAxyekUGesmeQcUbSWUrhm+obgmgqRntuEAbKWE+H4qHZzyvXQ
uA15ijWy1uIJUpU/qhjb5JRz6XTPBZMnujRC54UTQFdlcZRXR56h5+oXU7pH+joJ
oZ4e8qIGHDVN6knu8wxnNkPeu7D+Lu96Cj+DO08EAWyRz/W4D2aiAy5iG++3FYUV
oJfm4YuBdmM4QEbjOAqNgDY7wm5lbrvbw9Z0XX0+wOnlg8UyJEPBRtDPIBnIdrJI
aqAOni9dfafIweVQ8nExac34fJzs2CirQ8IxSkZiOtNEnmHdxMVW8JMhxd6Tsf4v
RknZT7uw6P75RT7vic+v0ibyq7gJ3uKUhR71L2L2uAwRnNVfJMqWPiVc/jGrXEOu
OgF5VRBvaEo3VD4UvPlALkuNzre5QYqLHE3G7p+g9FmNvzdGjiJ+3Ln8UlXhuE/I
B+igjMPYdj7QLkFVVWQpWEq3RuUc8usdY4kzmJjOQA4=
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

echo_info "Setup complete. Marzban Node is now running."
