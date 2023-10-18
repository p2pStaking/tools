#!/bin/sh

[[ "$1" != "" ]] && IP=$1/
curl -s http://ip-api.com/json/$IP ; echo
#curl -s https://ipapi.co/${IP}json
#curl ipinfo.io/$1

