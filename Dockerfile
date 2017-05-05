############################################################
# Dockerfile to build container with :
# - Apache 2.4
# - PHP 7.0
# - xDebug
# - mySQL
# - Redis
# Based on Debian
############################################################

# Build a Debian
FROM debian:jessie
MAINTAINER potsky <potsky@me.com>

# Non interactive mode for mysql install for example
ENV DEBIAN_FRONTEND=noninteractive

# Update the repository sources list
RUN apt-get update

# Install basics
RUN apt-get install -y apt-utils
RUN apt-get install -y wget

# Add dotdeb
RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list
RUN wget https://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg && rm dotdeb.gpg

# Update the repository sources list
RUN apt-get update

# Install basics again
RUN apt-get install -y zsh git curl vim htop curl vim htop

# Run oh my zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Install mySQL
RUN apt-get install -y mysql-server

# Install Redis
RUN apt-get install -y redis-server

# Install Supervisord
RUN apt-get install -y supervisor
ADD config/supervisor/app.conf /etc/supervisor/conf.d/app.conf

# Install SSH Server
RUN apt-get install -y openssh-server
RUN sed -ie 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Set root password
RUN echo "root:root" | chpasswd
RUN chsh -s /bin/zsh root

# Install Apache
RUN apt-get install -y apache2 apache2-bin apache2-data apache2-utils
RUN a2enmod rewrite
ADD config/apache/app.conf /etc/apache2/sites-enabled/000-default.conf
RUN rm /var/www/html/index.html
ADD files/app_tools /var/www/html

# Install PHP
RUN apt-get install -y php7.0 php7.0-apcu php7.0-mysql php7.0-redis php7.0-mbstring php7.0-opcache php7.0-xml php7.0-xdebug php7.0-mcrypt
ADD config/php/xdebug.ini /etc/php/7.0/apache2/conf.d/20-xdebug.ini
RUN sed -ie 's/memory_limit\ =\ 128M/memory_limit\ =\ 2G/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/\;date\.timezone\ =/date\.timezone\ =\ Europe\/Paris/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/upload_max_filesize\ =\ 2M/upload_max_filesize\ =\ 200M/g' /etc/php/7.0/apache2/php.ini
RUN sed -ie 's/post_max_size\ =\ 8M/post_max_size\ =\ 200M/g' /etc/php/7.0/apache2/php.ini

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Git Global
ADD files/gitignore-global /root/.gitignore-global
RUN git config --global core.excludesfile ~/.gitignore-global
RUN git config --global --add oh-my-zsh.hide-dirty 1

# Install PimpMyLogs

# Install PHPRedMin
RUN cd /var/www/html; git clone https://github.com/sasanrose/phpredmin.git
ADD config/phpredmin/config.php /var/www/html/phpredmin/config.php

# Set correct rights
RUN chown -R www-data:www-data /var/www/html

# Set root password
RUN echo "root:root" | chpasswd
RUN chsh -s /bin/zsh root

# Open ports
EXPOSE 22
EXPOSE 80

# Link Laravel App
RUN mkdir /app
WORKDIR /app

# Run
RUN mkdir -p /root/script /root/config
ADD files/run.sh /root/script/run.sh
RUN chmod +x /root/script/run.sh

CMD [ "/root/script/run.sh" ]
