FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -yq --no-install-recommends \
    apt-utils \
    curl \
    # Install git
    git \
    # Install apache
    apache2 \
    # Install php 7.4
    php7.4 \
    libapache2-mod-php7.4 \
    php7.4-mysql \
    php7.4-curl \
    nano \
    ca-certificates \
    locales \
    gnupg \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -s "https://packagecloud.io/install/repositories/phalcon/stable/script.deb.sh" | /bin/bash

RUN apt-get install -y php7.4-phalcon

# Set locales
RUN locale-gen en_US.UTF-8 en_GB.UTF-8 es_ES.UTF-8 

COPY conf/apache2.conf /etc/apache2/apache2.conf
COPY conf/dir.conf /etc/apache2/mods-available/dir.conf

RUN a2enmod rewrite
RUN a2enmod headers
RUN service apache2 restart

EXPOSE 80 443

WORKDIR /var/www/html

RUN rm /var/www/html/index.html

HEALTHCHECK --interval=5s --timeout=3s --retries=3 CMD curl -f http://localhost || exit 1

CMD apachectl -D FOREGROUND 
