# Using an official PHP image as the base image
FROM php:8.0-fpm

# Argument placed in docker compose file
ARG user
ARG uid

# Installing the app dependencies
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git \
    curl\
    libpng-dev \
    libonig-dev \
    libxml2-dev 

# Installing PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Installing Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Setting the working directory
WORKDIR /var/www/html/georgialaravel

# Creating system user to run Composer and Artisan Commands
RUN useradd -G www-data,root -u $uid -d /home/$user $user
RUN mkdir -p /home/$user/.composer && \
    chown -R $user:$user /home/$user

USER $user