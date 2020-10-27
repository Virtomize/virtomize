#!/bin/bash

COMPOSEVERSION=1.25.4

# check for correct distribution and os version
VERSION=$(cat /etc/*-release | grep -w VERSION_CODENAME | cut -f 2 -d"=")
if [ "$VERSION" != "buster" ]; then
        echo "this install script only supports debian 10 (buster)"
        exit 1
fi

# check if we run as root
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# https://computingforgeeks.com/install-docker-and-docker-compose-on-debian-10-buster/
# prequisites
apt update
apt -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common openssl git

# docker repo
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# install docker
apt update
apt -y install docker-ce docker-ce-cli containerd.io

curl -L "https://github.com/docker/compose/releases/download/$COMPOSEVERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

sudo usermod -aG docker $USER
newgrp docker

# virtomize installation 
cd /opt && git clone -b master https://github.com/Virtomize/virtomize.git

mkdir /opt/virtomize-scripts

touch /etc/issue.tmpl
cat <<EOF >/etc/issue.tmpl
  Welcome to Virtomize

  It may take a few minutes until the system is available.

  Please visit:

    - https://<IP>/ to use the webfrontend
    - https://<IP>/rest/v1/ to use the REST API

EOF

# change ip on start if something changes
touch /opt/virtomize-scripts/issue-ip.sh
chmod +x /opt/virtomize-scripts/issue-ip.sh
cat <<EOF >/opt/virtomize-scripts/issue-ip.sh
IP=\$(ip a | grep ens | awk '/inet/ {print \$2}' | cut -f1 -d'/')

while [ -z "\$IP" ]
do
  IP=\$(ip a | grep ens | awk '/inet/ {print \$2}' | cut -f1 -d'/')
done

sed "s/<IP>/\$IP/g" /etc/issue.tmpl > /etc/issue

EOF

touch /etc/cron.d/issueip
cat <<EOF >/etc/cron.d/issueip
@reboot root /opt/virtomize-scripts/issue-ip.sh
EOF

# run it to create the issue file
/opt/virtomize-scripts/issue-ip.sh

# set motd
cat <<EOF >/etc/motd

  ###################### VIRTOMIZE ######################
  #                                                     #
  #             Welcome to the Virtomize                #
  #                                                     #
  ###################### VIRTOMIZE ######################

EOF

# set update cron
touch /etc/cron.d/update
cat <<EOF >/etc/cron.d/update
* * * * * root /opt/virtomize/update.sh
EOF

# apache reverse proxy
apt -y install apache2

systemctl enable apache2
a2enmod ssl
a2enmod proxy
a2enmod proxy_http
a2enmod headers
a2enmod rewrite
curl https://ssl-config.mozilla.org/ffdhe2048.txt >> /etc/ssl/certs/ssl-cert-snakeoil.pem
cp /opt/virtomize/proxy/apache.conf /etc/apache2/sites-available/000-default.conf
systemctl restart apache2

# --no-start option used for creating virtual appliances for development
if [ "$1" != "--no-start" ]; then
  cd /opt/virtomize
  docker-compose up -d
fi 
