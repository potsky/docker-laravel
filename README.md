# docker-laravel

### Introduction

Docker file on a Debian Jessie with :

- Apache 2.4
- PHP 7.0
- mySQL 5.5
- Redis 
- SupervisorD for queues
- and all dependencies for Laravel

### Run

```
docker run -v /path/to/your/laravel/app:/app -i -p 2780:80 -p 2722:22 potsky/laravel
```

Then go to <http://localhost:2780> on your computer.

Useful tools are available at <http://localhost:2780/app_tools> :

- [PHPRedmin](http://localhost:2780/app_tools/phpredmin/public/)
- [PHPinfo](http://localhost:2780/app_tools/php_info.php)

Laravel default queue is automatically executed in a background daemon (`php /app/artisan queue:work redis --sleep=3 --tries=3`)

### Connect

```
ssh -l root -p 2722 localhost
```

Default root password is `root`.


### Dev

Build the new image

```
docker build -t my_laravel .
```

Run the dev image

```
docker run --rm -v /path/to/your/laravel/app:/app -i -p 2780:80 -p 27443:443 -t my_laravel
```

### ToDo

- install maildev
- install pimp my logs
- install phpmyadmin
- config mysql
- mount ssh keys for github
- install logrotate
- test xdebug

