#!/bin/bash

apt-get update

apt-get install curl socat git -y

ufw disable

curl -fsSL https://get.docker.com | sh


git clone https://github.com/Gozargah/Marzban-node


mkdir /var/lib/marzban-node


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
IBcNMjQwNzMwMjA0NzA3WhgPMjEyNDA3MDYyMDQ3MDdaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAlFMLqDHR+5rA
0C1afHLaYa7sbWqtaTN1OCBPcANrtBVo0ve7sWbF6aFTpymNrfiZNuvCqk6ciVTn
MzjJ8CQTn7VhB5Mbzy2kAqGWQQEH2mg3ZWLrbRYGdQQxqQ6Lq7ktejwR5jUdt/Ok
c/v6igF4ljLk+8mkstbDTS+QTlI3xeLam4LVDSTE1YtNQCOO1ALIGbwabNRLRk71
EzOdMQt4NNYSrx5Ag1BziS7g4q0ZPz8M7ES4eIOHdmgicB9Cok9GimQSxVpE4g02
RTIZarixX2WRFSZvUYvaLmGk5luyvk70ZG/uwXpcf5A8bJlKcyRiE5Ku/lbp8pi5
cN2jYE7WUDM5Q2QiQUP0IgNDdJK5YwKj7VqoliU6M0TKpGJ/J5jYyMnb5JKHwMHU
EUUqzlRhbLnMSP5536WuV//ND9+R3Zp43Ho9kBPXZ5FjDEieprSQeQ391qGaz/Zu
BHC66SPfHj+ed5ouGli5NS1YzDpFbhnnV1z+DB4Ocsw4mifNPlTTF0ohfPTcvy+e
KOb79HzUMpj+fvRp7WO1is9Ru4Z27oGOBw2zeVXHbC9crga7f9XyvhXS9+tFnI/j
QRvSlxYRHXT1CNWvhpHNdknLQhZElYaPqxsMeqr73XzU7cuTbMx4iQXJKuoeWgJU
UBI7otVs4iK7+QobsTpflLUKlj5FQccCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
ctEBcxbT5OzlrwMLOPAYKTk9WeoWBTJ00TZyVLbLydQGdtz8E2A3iIj4ohC34Yyx
v3R6k5qXQgUh7a/y7qTNgamoavTz8YhO1cgEpDPSAu7fBZGVWOKt80jCzl6lTkth
CsWSVMXTQsEYrQdnTmOq4H406pcnh1rzWpaFQt2OBUn5gWi5WU9nLTjaaRrjkWra
kpf49NYJxIyHDFuNk56sSiM3GSS0ChONZfjeeyxuBZg9WOnUbVZAtRplT1QVcVyZ
ZJX+aqpttOTIkeeE1s2YwIRU3taf9e3fwh3JOIvo835hD1OGjmA5VUXBJMFAyvn8
anYxFNxkZH3g0qkD9FIFSC3DyVQ6X1Nd7LtBtd8CBheU/ZSyb+g6kzmcn97gQbUb
gXaCkrQb6uA2qJgnz3HgHaS7cOCcLoRILEUBEiYKMOay2GGtSqLQL+Awbx+cjfqo
aXgdZBU/J1AkmekVQttwU95GsMCPQcVw8Jm7nE4ZdI/pmKBXpok7sc7TsgXm9XSb
rfNMQgcje1MIt9oqsXJMyApUSjkXCw1a8S/ob5zC0sf6y+OMtt0914rv+BXFf+w/
lm3vqcblOiMZ6pwbFWki4Q4nDsNbDIOL7BE7g8N+DgpzS+gMoQhnCUUvJzRJX1Kq
b73857nAgyKjBAf/JLpREqOQere4jDisd4f9rqwa78E=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d
