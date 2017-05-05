#!/bin/zsh

# Start SSH
service ssh start

# Start MySQL
service mysql start

# Start Redis
service redis-server start

# Start Supervisord
service supervisor start

# Start Apache
service apache2 start

# Gime gime gime a shell after midnight
zsh

