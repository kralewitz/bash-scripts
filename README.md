# bash-scripts
A collection of random (and hopefully useful) bash (and maybe other) scripts.


### letsencrypt-renew

This script is used for automatic renewal of Let's Encrypt certificates using the **webroot** authentication method.
Apart from the script iself, there are two more things that need to be set up:

1. The configuration file `config.ini`, which contains a few common options:
```
rsa-key-size = 2048
email = admin@example.com
text = True
agree-tos = True
renew-by-default = True
authenticator = webroot
```
2. For each domain on the server, a special location for the Let's Encrypt challenge auth has to be set up:
```
# /etc/nginx/conf.d/example.com
# ...
    location ~ /.well-known {
        allow all;
    }
# ...
```

The script can be then run via cron:
```
# /etc/cron.d/letsencrypt-renew
30 10 */2 * * root /root/scripts/letsencrypt-renew.sh
```
