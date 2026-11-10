# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production \
    APP_DEBUG=false \
    APP_KEY=base64:your-app-key \
    QUEUE_CONNECTION=redis

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install zip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy composer.lock and composer.json
COPY composer.lock composer.json ./

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy project files
COPY . .

# Run migrations
RUN php artisan migrate --force

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
