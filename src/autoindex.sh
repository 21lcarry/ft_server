#!/bin/bash

if [[ "$1" = "off" ]]
then
    sed -i '23s/on/off/' /etc/nginx/sites-enabled/site.conf
    echo "autoindex off"
    service nginx reload
    exit 0
elif [[ "$1" = "on" ]]
then
    sed -i '23s/off/on/' /etc/nginx/sites-enabled/site.conf
    echo "autoindex on"
    service nginx reload
    exit 0
else
    echo "wrong arg"
    exit 1
fi