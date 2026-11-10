# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies
RUN composer install

# Copy the .env file if it exists
COPY .env .env

# Expose the default port for Laravel (80)
EXPOSE 80

# Start the PHP-FPM service
CMD ["php-fpm"]
