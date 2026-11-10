# Use the official PHP image from Docker Hub
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    git \
    curl \
    zip \
    unzip \
    composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql gd

# Install Composer dependencies
RUN composer install --no-scripts

# Copy the entrypoint script to the container
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Set environment variables for Laravel
ENV APP_ENV=local
ENV DB_HOST=db
ENV DB_DATABASE=homestead
ENV DB_USERNAME=homestead
ENV DB_PASSWORD=secret

# Expose the default port for Laravel
EXPOSE 80

# Define the command to run the Laravel scheduler
CMD ["docker-entrypoint.sh", "php artisan schedule:run"]
