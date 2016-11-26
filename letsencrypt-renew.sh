#!/bin/bash

set -euo pipefail

_IFS=$IFS
IFS=';'

EMAIL="admin@example.com"
DOMAINS=(
  "www.example.com;/var/www/example.com"
  "other-site.example.com;/var/www/other-site"
)

for web in "${DOMAINS[@]}";
  do
    set -- $web;
    /usr/bin/letsencrypt \
      --config /etc/letsencrypt/config.ini \
      --webroot \
      --webroot-path $2 \
      --domain $1 \
      certonly;
    if [ $? -ne 0 ]
      then
        LOG=$(tail /var/log/letsencrypt/letsencrypt.log);
        echo -e "Failed to renew the Let's Encrypt cert for $1\n\n $LOG" | mail -s "Let's Encrypt Renewal Failed" $EMAIL;
      else
        echo -e "Sucesfully renewed Let's Encrypt certificate for $1!\n" | mail -s "Let's Encrypt auto-renewal success" $EMAIL;
        systemctl reload nginx.service;
    fi
  done

IFS=$_IFS

