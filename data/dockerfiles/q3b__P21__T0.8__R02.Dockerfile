# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    zip \
    && docker-php-ext-install zip pdo_mysql

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose the default port for Laravel
EXPOSE 80

# Define environment variable
ENV APP_ENV=local

# Start Nginx and PHP-FPM
CMD ["php-fpm"]
