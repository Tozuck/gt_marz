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
IBcNMjQwNjI0MTMxMzI1WhgPMjEyNDA1MzExMzEzMjVaMBMxETAPBgNVBAMMCEdv
emFyZ2FoMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA5Gr47QcFI2pi
sOgp+rhgTJU/DNVtJwMHBru+g53e/sZbdkCFbKb/t3971lhD/FTmEyyPsH3Y3Kkm
qsnvnyb8dBHLThWCfUhAVmPd0b3vQBF8hciBUTFHQT0BCb/TTv64+VI9mIAbgdE8
PnIfrH/dq7MMsm4LHm0C62OXWsgOl9xfq/KA72Yub8G+6hwzZaaSED7gMEFWRkzw
MBW+9UsPXT3O1rup5U30RcLRHUb/AamZe6SMmWwTVC1PAnkSbY1gxF36ZUxmUgSa
iG4bwfRTSw39WFro4Exo9hDXWYyhurxJaXgb3nTcCZ4m2RbuKllrIyfe7gXX88cZ
uhp7HChnfN/wNLtHxsZbhzxv4LccdYSP21X4YaR2wvchxfaZQUPRVxKO0IVY7hTt
5qhbNplrlQ2lY4x9WMDYC4yTJePBl/hBZUU0j2CgrD6BMDhCmTfk4F+D0e8W6EvR
tGvdBG+Ut2TwrjwtW4y8nYql3+plKgKTReUHtYG3NkCa3iY2LWhlz3sh2HRflITb
woWVWUSaBQW5D4JoEu2aKypbFiCmgyxAYTEl6x2HWRHwtwcX/uLJ684eMbdf3esA
XD3/Ka4+BCYAYre4rtUjR1325jcMGHv3fveGBSiio/IuB1ociS7SwgcXiYK0s3cm
f/R+qzLvUK/4oD5iAOCP3Jw1oaM81Q8CAwEAATANBgkqhkiG9w0BAQ0FAAOCAgEA
AfyksQYKy+e/91FYCztc+eNEGdy/vkiYFUGnLMS8ggBRJi4a+R8EuxCuYTSbN7aH
fSEIG6ChrA4l+zehcZBRa9jppO5Bsu43cOPwhaM0HXzDhykhPLxM/qF0NjsMHCVV
Th5o+RkxENPaGV8aHqJ+Hi40MOCIue4i1Bx8/zLpnb/yH3sPeVal3h0BB20b1QRy
o3Ppa2d8yDGbD6Bx+CKek5TfwX3lOxDDyEw7GxT2oWla6vgHjtESyrT7xUQkRaW3
Xt3pxUCKEbR/J+8h4fN/y2Q2GSQ9WrAV0tAno3NPhH6lGBDKsDbKtjvAxhhARj8o
A5DXvQeDXECzf0QfCQXTaaFpcZBKYsyF+NnR9Bq/5i8yhN2MyL9cyN7BSQvSZIxc
9EfpaOB0wCM5Jnv80mCsAa0i7U5AbJWaWXK8aLH5tvcAZLvUxEkp5LH2yJPyYUIm
bWLyGTTmLjC2mAXSa5z57aiGoKfsgrzSdgTdzrm9DHq6la1wMphZ0u4xxDXtQqh/
+QZC/6p5gA/K8rKh3/0jjCDzvnCFFRITID97gTxmE4r3YI/AxOVDgypL1UuZl0bz
eZMXhfthyt3Qz6Z2swYohLasKb3mOKxvOPu3mcPPVhfhmStXeH5KGOV7zEwb1uhL
ectTkX/PsJboW2dQ88fb4sFgCoWmJe/bTUHNptGsxEM=
-----END CERTIFICATE-----
EOL

cd ~/Marzban-node
docker compose up -d
