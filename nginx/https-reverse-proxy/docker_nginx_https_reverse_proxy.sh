#!/bin/bash

docker pull nginx:latest 

docker rm $(docker stop nginx-https-reverse-proxy)

cd "$( dirname "${BASH_SOURCE[0]}" )"

[[ "$NGINX_SERVER_NAME" == "" ]] && NGINX_SERVER_NAME=$(hostname --short)

# assuming that /srv/tls content server.crt and server.key certificate files
docker run -d --name nginx-https-reverse-proxy \
	--network host \
	--user root  --restart always \
	-e "NGINX_SERVER_NAME=$NGINX_SERVER_NAME" \
	-e "NGINX_SERVICE_TARGET=$NGINX_SERVICE_TARGET" \
	-e "NGINX_LISTEN_PORT=${NGINX_LISTEN_PORT:-443}" \
	-v ./nginx.conf:/etc/nginx/nginx.conf  \
	-v ./reverse-proxy-https.conf:/etc/nginx/templates/reverse-proxy-https.conf.template \
	-v ./default.conf:/etc/nginx/conf.d/default.conf \
	-v /srv/tls/:/etc/nginx/tls/ \
	--security-opt apparmor=unconfined \
	nginx:latest

#docker run -d --name nginx-https-reverse-proxy \
#        --network host \
#        --user root  --restart always \
#        -e "NGINX_SERVER_NAME=$NGINX_SERVER_NAME" \
#        -e "NGINX_SERVICE_TARGET=$NGINX_SERVICE_TARGET" \
#        -e "NGINX_LISTEN_PORT=${NGINX_LISTEN_PORT:-443}" \
#        -v /srv/tls/:/etc/nginx/tls/ \
#        --security-opt apparmor=unconfined \
#	p2pstaking/nginx-https-reverse-proxy

docker logs -f nginx-https-reverse-proxy

