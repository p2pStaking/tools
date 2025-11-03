FROM  debian:latest 
SHELL ["/bin/bash", "-c"]
RUN  apt update 
RUN  apt upgrade -y
RUN  apt install -y jq bash curl git nodejs openssh-server npm
RUN  npm install -g eth-cli
RUN  npm i 0xweb@0.9.97 -g

