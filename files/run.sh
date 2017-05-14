#!/bin/zsh

# Start SSH
service ssh start

# Start MySQL
service mysql start

# Regrant access to debian user
# mysql -s -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' IDENTIFIED BY 'X0dRgHfyx3OyAL5h';"

# Create database and user if not exists
if ! mysql -s -u root -e 'use laravel' 2>/dev/null; then
	mysql -u root -e "create database laravel; grant usage on *.* to laravel@localhost identified by 'laravel'; grant all privileges on laravel.* to laravel@localhost;";
fi

# Start Redis
service redis-server start

# Start Supervisord
service supervisor start
chmod 755 /var/log/supervisor

# Start Apache
service apache2 start
chmod -R 755 /var/log/apache2

# Start Maildev
maildev > /dev/null 2>&1 &

# Gime gime gime a shell after midnight
zsh

