# Use an official PHP runtime as a parent image
FROM php:8.1-cli

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /var/www/html

# Install application dependencies
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Set the working directory and command to run the application
WORKDIR /var/www/html
CMD ["php", "bin/console", "app:command"]
