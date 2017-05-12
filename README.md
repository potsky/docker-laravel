# docker-laravel

### 1. Introduction

Docker file on a Debian Jessie with :

- Apache 2.4
- PHP 7.0
- mySQL 5.5
- Redis 
- SupervisorD for queues
- and all dependencies for Laravel

It does not respect the single process docker style but this is the best way to make dev happy 😄

### 2. Run

```
docker run \
	-v /path/to/your/laravel/app:/app \
	-v mysql:/var/lib/mysql \
	-p 2780:80 \
	-p 2722:22 \
	-p 2790:1080 \
	-ti \
	potsky/laravel
```

Then go to <http://localhost:2780> on your computer.

Tools are :

- [PHPmyAdmin](http://localhost:2780/app_tools/phpmyadmin/)
- [PHPRedmin](http://localhost:2780/app_tools/phpredmin/public/)
- [PHPinfo](http://localhost:2780/app_tools/php_info.php)
- [MailDev](http://localhost:2790)

Laravel default queue is automatically executed in a background daemon via `php /app/artisan queue:work redis --sleep=3 --tries=3`

Simply `exit` from the shell to stop the container.

### 3. Connect

#### 3.1 MySQL

1. Root account has no password and login is `root`.
2. Laravel account is :
	- login `laravel`
	- password `laravel`
	- database `laravel`
	
In your laravel `.env` file, you just have to use this :

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=laravel
DB_PASSWORD=laravel
```

And execute `php artisan migrate` to create database tables.

If you run the image in a container without the `-v mysql:/var/lib/mysql` option, then the volume will not persist between two runs.

If you run the image with the `-v mysql:/var/lib/mysql` option, the database will persist between two runs. To remove the storage, just execute `composer volume rm mysql`.
 
If you have deleted all containers, run `docker volume prune` to remove all orphan volumes.

#### 3.2 SMTP

In your laravel `.env` file, you just have to use this :

```
MAIL_DRIVER=smtp
MAIL_HOST=localhost
MAIL_PORT=1025
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null
```

#### 3.3 SSH

```
ssh -l root -p 2722 localhost
```

Default root password is `root`.


### 4. Dev on this image

Build the new image

```
docker build -t my_laravel .
```

Run the dev image

```
docker run --rm -v /path/to/your/laravel/app:/app -i -p 2780:80 -p 2722:22 -t my_laravel
```

---

### ToDo

- install logrotate
- test xdebug

