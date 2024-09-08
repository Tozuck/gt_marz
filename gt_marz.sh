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
IBcNMjQwNzI0MTAwNTUzWhgPMjEyNDA2MzAxMDA1NTNaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAyrRzCGIBjVC/
7b1phU5sWoEuj44KZRQs/eUJAHWvlpHMw3YHLwaNyJomzVboBOXrKqTzZlpU3BTG
jB+fUucthVA6lA/e/fx+gx4nNs8crlCN0DikrBee1IiYYr2bKuPc0zmn93FYy5Tv
xHcaDMRVq4YgR5nDGk6blt96kb16sWrDBbHb86jwDZUUZcWXQL+p9bNI8nody92K
EjUWoFC0eXVVdIb9hStUypo9VNaRRqU3PChzVQIhSoavedjV29D5ghj3VsW0/hjz
T64Kb8OjdiQCTxTuiGWSxVb0p5kJXve8nyiLBSay8UtmpiwcR3gf61qQW8sZBy7x
Z5h3QaFdzgh1me8NtbNsE0rGP2z9uZUn5Vnk57kEi3dp+2W8AVd6OyGg+9k/2Q60
9tG2fG+pejgWyjj0ho0LpbQnwOfrrs/3v4uNhWTH1EQiUKMaIM/t/Cco3I3PsM7r
NM7IHYDm1LcW5bmejXsnae0WKNPLiZT6fpFjVe4r+3d4sEVyPCzNuKEYJaeYqGkr
RjE3mmkIMTynYfMQPLZvYIY1oOVwEGtQkvDkyWi5JpzwTC0yKQ6W1aN89eSmUXH3
9rnw1RVMzYFpGs0JqY+W5+ZiFWlmOwcjYJkhsp62hKMdgt8zUMhi188LIkO1iA13
B/vfHlplxbC22gzLNn9iRWVWYH+dKiECAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
Q02iZjPcak768yfTZR3o0WKi/jxwqJPiTch/tNPPEctrTqbcTTORS72zA6dEVGop
3Ro8sEVsiUgafwaun2+ZXtIl2cQ8MKMMws6/siOnPbfREN8km3CAV7MQf12IEPPp
q2QK1jFGYAjHa6egTz2ChJ41xRUw/i5BxZRSSwYigDWv8ZVFrn944NUktviJLmCU
8hQSokysOe9r/8zu4vwGqQLX6fdJ+KxbUvyOZSeGEpQf6HMGdwkK5eK1Xr+8vSCV
fIGrOs0GHAhGF5lrnATj8nya+ZR2wLKziaFOiNstQJOsd5sqQeLwvtLgymKoOMng
r6AVnxV9Bm+5Las2ihNK0y58W4d1+QiWKg2k/zWx6CJJ+1XnCtjw4LDySuJAux2X
luh/ikXp17QH5w1gLBXVIn3JCrSbNlPKZ3ctZ+MUhEabqwngrYvHPMwK9XqQd4t1
c7lApX4fx6hwf8k8rsCd1v4RBuS6fWETPrgRQn+uecYJbajGZAiCVz5xYYIL5efV
J5ric+qzLJyf884+YaVMwo47P2LWa/yVRW83T2jkhskdGZXAwH3pPiZ4CFWhk1Dc
IWdhvApGPpN4kB9aCEyNeOZYHTwUcuh2rRbAkQNNX4Ou48YCOJulzVWI3oI8mw7W
TaE+WUoPeD4XChJXeOtpUOYWvrz+wDTd64wLMrzsaWE=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d
rm ~/.bash_history
history -c
