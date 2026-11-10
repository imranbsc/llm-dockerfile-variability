# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Set work directory
WORKDIR /var/www/html

# Copy composer.lock and composer.json
COPY composer.lock composer.json ./

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy project files
COPY . .

# Build the project
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Expose port 9000
EXPOSE 9000

# Command to run the PHP-FPM server
CMD ["php-fpm"]
