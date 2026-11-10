# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV production
ENV APP_DEBUG false
ENV APP_URL http://localhost
ENV QUEUE_CONNECTION redis

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --prefer-dist

# Run migrations
RUN php artisan migrate --no-interaction

# Command to run the worker
CMD ["php", "artisan", "queue:work"]
