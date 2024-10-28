#!/bin/bash

apt-get update

apt-get install curl socat git -y

ufw disable

curl -fsSL https://get.docker.com | sh


sudo git clone https://github.com/Gozargah/Marzban-node


 sudo mkdir /var/lib/marzban-node


cat <<EOL > ~/Marzban-node/docker-compose.yml
services:
  marzban-node:
    # build: .
    image: gozargah/marzban-node:latest
    restart: always
    network_mode: host

    # env_file: .env
    environment:
      SSL_CERT_FILE: "/var/lib/marzban-node/ssl_cert.pem"
      SSL_KEY_FILE: "/var/lib/marzban-node/ssl_key.pem"
      SSL_CLIENT_CERT_FILE: "/var/lib/marzban-node/ssl_client_cert.pem"
      SERVICE_PROTOCOL: "rest"

    volumes:
      - /var/lib/marzban-node:/var/lib/marzban-node
EOL

# Create SSL certificate file
cat <<EOL > /var/lib/marzban-node/ssl_client_cert.pem
-----BEGIN CERTIFICATE-----
MIIEnDCCAoQCAQAwDQYJKoZIhvcNAQENBQAwEzERMA8GA1UEAwwIR296YXJnYWgw
IBcNMjQxMDEzMTQwMjI2WhgPMjEyNDA5MTkxNDAyMjZaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEArmf8GVX4coVz
1D9e2OtvpSyaaI0cbnNOGUpfoOBwAJtRrWH3jPCyb7BnglKplCO1G1rHkeiR/tUA
PDm09oJpHSs/t5C34N1UUuw+vYdJrx2KY043FUhb7xwrDFA93wXkUtyZp752IOL3
vZPZBX2Cc1GelQNEtgpVklLM3R4RzlpjC6TMaJ16MJgQGq1byNjhv5kKN7XsJbus
NN+qx+NBvaBApAvtaqtNPXhoAvWP/69uGkcSQIY2kiDYCC+ACJP50z3+uCf5gY1e
K0SgXZ2EwmR9nUPyrDc+znb0tbWYC6Q06WOloJfMOgy+0nzegj7yf72MZnfcObKj
FAxYLG6C1sjd8M+3asEE7eFyNbaC546BwCoX98Jqtckrxh5NgYfiFPRKW4GdcJzU
Dmc4EjDtSdJv30H15f22gw6Ltj/VWT3cjVnNWfgLQdv5/8EtYBNjJOVUYAz5C+IY
V2KtYoYqNVahD5dP7v1q7NfYmbmw+Go/crnaPDQCb89kCcn4yWqOnTN4+fClf8XV
MH27NWGDmJ/TQcpKDefh+xel56R8bNB3C11Wb62kYrP9NKxMPgt8ETRFYVv+fUWt
mTBbeKSMERNhpJJeJ9uXzxx9F2Alb0AbDYDvK3RxPsnywUV4aQtLT/C0epMunV6s
MmtDa9Tb8INFccQacl8z9T2ZMQL3YzsCAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
Bqw6UsOghAHau0/yvo/mAFV1UULHIzchiRd1IQ8LIsZepDxIAn1kCyFkiRaLYs8K
pCA/WJWXIXtQUNc3zmZGaWGkUGe+euI6MOmeI/ok9vEpy0ZnP5yYwZky7UgD+xkq
aRT1aJGMh8rerBByjBQA9gLFOjireLWPLDV2EnbHmN4Ob2ac7SzQoD/zRv5UezwA
hL/LC6BHydQRac6tnb+5khJoYeupb2sz+ipNW1Dgf1wggjqyuj+nWT18932+nU1q
CGogDQehg94eOrhcVXhs8TR/OttlPx0CFNyEyLF+k3yZ+aPLwqH98/CzkUiRflgk
UeL6JuI7maZxUx4Z7zmz941Pbr3RNjWI3Xpkmp2QvzkrjITsO36gLIZ6NFgd/1eJ
cfxQbNA/swGWpMy4LSOrBksfZUmXqVuenwPaKe/GPh8Rc7d53Bkq5IAL+6yPTSUf
0TIeyFBDq81s4yP89jysdoeM6VSOlAkwd40lVhOjR9mmxCeqZ/7apM/Ip7WuwYLO
ka8jdrZ3PSj4eacoFttpo4m4YnCWp1KcUZCVUKsrKcCB8/Lg5jCWv1T1UYxeWxWT
LoP6TExvhnuP9aSiV0uEW1d8a2+WPn3L1GtHo0vH/eHocYPs3YyPHOuxHw6QmZ6y
8dPKkNMkvQW4Q+BUYCmKnVW4yQ98cJCISrfitbbhEu8=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
sudo docker compose up -d

history -c
