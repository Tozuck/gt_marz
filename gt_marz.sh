#!/bin/bash
# GT_marz: A script to set up Marzban node

# Update and install necessary packages
apt-get update
apt-get upgrade -y
apt-get install curl socat git -y

# Pause for 2 seconds
sleep 2

# Disable UFW
ufw disable

# Install Docker
curl -fsSL https://get.docker.com | sh

# Pause for 2 seconds
sleep 2

# Clone the Marzban-node repository
git clone https://github.com/Gozargah/Marzban-node

# Create directory for Marzban-node
mkdir /var/lib/marzban-node

# Pause for 2 seconds
sleep 2

# Edit the docker-compose.yml file
cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    environment:
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL

# Create SSL certificate file
cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjQwNjEzMDgyMjQ2WhgPMjEyNDA1MjAwODIyNDZaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5gnxWXw1GAaX
NxYBdbxOehUYDcSKhlwKMrt1x19eecKXleKGBPs58cfSm0QaB0VH2r491sGhX263
CRpTraDyjdd1fPu38L2YqW/ExL+ug7Ojj/QTYdiuxaP88qAWLBZq2NJvHEO6hDxF
YWpuQby1cYzQT1Ro9/fXwV4v1Lr1Ye96bLxZShor6cs/huiZ1sxGBJZAH3YVXPLJ
OUjbWhL/2H+JLnavSq5B+RS9GJ/n4EpCNbxFrPz8yNMqBBHoHVbeAGRFNxEUwqxI
joDiTmdqXfLEf5c2l4/hh0CwniT9Sxe9IaUepepCief/60MqEjj5YjR/LN2t0UAU
yVDmN7LWjm/5vu3lvvijdCpepRqBWm75zMpEprlJgGQStOyQYOg1iiNYla4L3c3e
xGCbkGVNXX0VeAnJAFPtUVdaBppkNOu5QRHE3AIWwJXDk1p783vL7FniZBfYgRKe
I/656aVmz27nhYKKAuZz+F7c82JnD+KhSnQH4IYLU5/XyiXfRijcN7pWEemkY8kx
nRALCJsG0/OGOzcum/dOeU+iF7pXwMeneGEsHlR+m2voERAHVpWNaFiDVu2pZaOR
3ivR2VSYJJSTLVGDvP0TLTZLYAooSeaaxP7k17HRsejPjR+Et2KlK9G/J2tGUQVQ
zv/9n5Yg2b5zHt2S0CRe6YlBMmng8u8CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
bItfSu1wqBvYMX9p2AUkagzjvrzYAxN+bbljInd3Cyk3leu+wAZZjl9CtugcW1Ut
A8XUbomz204LrNIIzjO3JhZ4xsEtNl51EFG17Vywuu8Br9azpdA7jko4SsoF3OT/
b+fzU17xO88ac/SLWyCgyaAgt5gyzU0O1DLsiRhLcuxI9VW4pgu2JY6dZUHhNVUa
AVnOnKbf/WjVoZgPFkTso4MrpxyYvn6iVumHO6lu70fDGKOjkV49ZGEONeQzaqpy
LvHfDoPJa/3xxRyjTl8ql/CXJIlAhH0m8JDuJedXx5Iq18QGHy3MJq19bb16VtlV
DxYHvDFdHLKz66czJYjA7r4X1peyFcpStlMwRhI/ZNCCjXaAQcmAEwMLSyB9XLv7
VoSA4lXzIdF54qQY9bVWjYlLcVMK5K87XjnO00V8G08n1bT38Svc8zTxyoa4KHU6
7I8m41CXow2eGyjV50hmYZm4Trc5exqDVsaiXEwEN2esK9W6xzr3gOqKOLaMeGhP
HIQJUyez/84SUkepBE7EkgtHS5F1Cyk/yEntD3Ajoge0AZm6VzvoGJPl9xdasVmO
Y3jPDgaJRthO1WzAge+pM5nQorzbY8i1A/4BOGMfVCaEOX8ZV3X4iRHIm6HfaaM/
YVc7glxqVB/tvq+P87mCC6d9Qrbd9Tanw1NzvlI9LNg=
-----END CERTIFICATE-----
EOL

# Pause for 3 seconds
sleep 3

# Run Docker Compose to start Marzban node
cd ~/Marzban-node
docker compose up -d
