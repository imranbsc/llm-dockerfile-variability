# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    cron \
    curl \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Clear cache
RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy crontab file
COPY crontab /etc/cron.d/laravel-scheduler

# Give permission for cron
RUN chmod 0644 /etc/cron.d/laravel-scheduler \
    && crontab /etc/cron.d/laravel-scheduler \
    && touch /var/log/cron.log

# Expose port 9000 and start php-fpm server
EXPOSE 9000

CMD ["php-fpm"]
