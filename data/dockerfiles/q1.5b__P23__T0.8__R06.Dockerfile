# Use a base image for PHP
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl \
    zip \
    unzip \
    && docker-php-ext-install pdo_pgsql

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Laravel dependencies
RUN composer install --prefer-dist

# Define environment variables
ENV APP_KEY=base64:your-app-key-here

# Expose the port Laravel will run on
EXPOSE 8000

# Define the command to run the worker
CMD ["php artisan", "queue:work", "--daemon"]
