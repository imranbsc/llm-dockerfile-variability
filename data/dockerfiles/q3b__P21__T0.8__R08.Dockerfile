# Use an official PHP runtime as a parent image
FROM php:8.1-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libpq-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_mysql zip exif gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies specified in composer.json
RUN composer install

# Expose port 80 (HTTP) and 443 (HTTPS)
EXPOSE 80 443

# Set environment variables
ENV APP_NAME=Laravel
ENV APP_ENV=local
ENV APP_DEBUG=true
ENV DB_CONNECTION=mysql
ENV DB_HOST=127.0.0.1
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=root
ENV DB_PASSWORD=secret

# Run the command to start Apache
CMD ["apache2-foreground"]
