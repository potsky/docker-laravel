#!/bin/zsh

# Start SSH
service ssh start

# Start MySQL
service mysql start

# Create database and user if not exists
if ! mysql -u root -e 'use laravel'; then
	mysql -u root -e "create database laravel; grant usage on *.* to laravel@localhost identified by 'laravel'; grant all privileges on laravel.* to laravel@localhost;";
fi

# Start Redis
service redis-server start

# Start Supervisord
service supervisor start
chmod 755 /var/log/supervisor

# Start Maildev
maildev

# Start Apache
service apache2 start
chmod -R 755 /var/log/apache2

# Gime gime gime a shell after midnight
zsh

