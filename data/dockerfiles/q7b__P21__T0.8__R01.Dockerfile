# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set environment variables
ENV PHP_ALLOW_URL_FOPEN 1
ENV COMPOSER_ALLOW_SUPERUSER 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    zip \
    unzip \
    git \
    curl \
    libxml2-dev \
    libzip-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libwebp-dev \
    && docker-php-ext-install pdo_mysql mbstring bcmath zip gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy composer dependencies
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy application code
COPY . .

# Install additional PHP extensions
RUN docker-php-ext-install pcntl

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
