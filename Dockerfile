# Using an official PHP image as the base image
FROM php:7.4-fpm

# Installing the PHP dependencies
RUN apt-get update && apt-get install -y \
    zip \
    unzip \
    git 

# Installing PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd xml zip dev curl mysql

# Installing Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setting the working directory
WORKDIR /var/www/html/georgialaravel

# Copying aqpplication code to the working directory
COPY . /var/www/html/georgialaravel

# Giving the appropriate permissions for the Laravel application
RUN chown -R www-data:www-data /var/www/html/georgialaravel \
    && find /var/www/html/georgialaravel -type d -exec chmod 775 {} + \
    && find /var/www/html/georgialaravel -type f -exec chmod 664 {} +

# Running composer install to install the dependencies
RUN composer install --no-dev --optimize-autoloader

# Copying the environment file
COPY .env.example .env

# Generating an application key
RUN php artisan key:generate
RUN php artisan migrate
RUN php artisan migrate --seed

# Exposing port 9000 for the PHP FPM process
EXPOSE 9000

# Exposing port 80 for the Apache process
EXPOSE 80

# Defining the command to run when starting the container
CMD ["php-fpm"]