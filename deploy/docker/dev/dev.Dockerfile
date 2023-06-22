# docker build . -f singlehost.Dockerfile --platform linux/amd64 -t bubify
# docker run --platform linux/amd64 -it --rm bubify
# docker build . -f dev.Dockerfile -t bubify-development
# docker run -it --rm bubify
# Download base image ubuntu 20.04
FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="jonas@norlinder.nu"

RUN apt update

RUN apt install -y nginx maven openssh-server
#git && \
# rm -rf /var/lib/apt/lists/* && \
# apt clean

RUN apt install -y git
RUN apt install -y wget apt-transport-https gnupg
RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
RUN echo "deb https://adoptopenjdk.jfrog.io/adoptopenjdk/deb focal main" | tee /etc/apt/sources.list.d/adoptopenjdk.list
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update
RUN apt install -y adoptopenjdk-15-hotspot nodejs nano npm
RUN npm install -g npm
RUN apt install -y sudo curl tmux emacs

RUN useradd -ms /bin/bash bubify
RUN usermod -aG sudo bubify
RUN echo "bubify     ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/bubify/.ssh && chown bubify:bubify /home/bubify/.ssh
COPY --chown=bubify:bubify ssh/id_rsa /home/bubify/.ssh/id_rsa
COPY --chown=bubify:bubify ssh/id_rsa.pub /home/bubify/.ssh/id_rsa.pub
COPY --chown=bubify:bubify ssh/config /home/bubify/.ssh/config
RUN chmod 600 /home/bubify/.ssh/id_rsa
RUN chmod 644 /home/bubify/.ssh/id_rsa.pub

COPY nginx/default /etc/nginx/sites-available/default
COPY nginx/nginx.conf /etc/nginx/nginx.conf

WORKDIR /home/bubify
COPY --chown=bubify:bubify start.sh /home/bubify/
RUN chmod +x start.sh

USER bubify
RUN git clone git@github.com:IOOPM-UU/auportal2020.git portal --branch=configurable
RUN mkdir -p au_backups
RUN mkdir -p profile_pictures
RUN mkdir -p keystore

# Setup intermediate certificate
WORKDIR /home/bubify/keystore
RUN keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 -keystore keystore.jks -validity 3650 -storepass password -dname "cn=Unknown, ou=Unknown, o=Unknown, c=Unknown"
RUN keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 -storetype PKCS12 -keystore keystore.p12 -validity 3650 -storepass password -dname "cn=Unknown, ou=Unknown, o=Unknown, c=Unknown"

ENV AU_KEY_ALIAS=tomcat
ENV AU_KEY_STORE=/home/bubify/keystore/keystore.p12
ENV AU_KEY_STORE_PASSWORD=password
ENV AU_KEY_STORE_TYPE=PKCS12

ENV AU_BACKEND_HOST=
ENV AU_FRONTEND_HOST=
ENV AU_APP_API=
ENV AU_APP_WEBSOCKET=

ENV AU_DB_HOST=localhost
ENV AU_DB_PORT=3306
ENV AU_DB_NAME=ioopm
ENV AU_DB_USER=ioopm
ENV AU_DB_PASSWORD=CHANGE_ME
ENV AU_GITHUB_CLIENT_ID=CHANGE_ME
ENV AU_GITHUB_CLIENT_SECRET=CHANGE_ME

ENV AU_PROFILE_PICTURE_DIR=/home/bubify/profile_pictures
ENV AU_BACKUP_DIR=/home/bubify/au_backups

ENV AU_DEV_MODE=

EXPOSE 80

WORKDIR /home/bubify/portal
RUN mvn compile

WORKDIR /home/bubify/portal/frontend/
RUN npm ci

WORKDIR /home/bubify/
CMD ["./start.sh"]
