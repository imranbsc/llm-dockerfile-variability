# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Configure PHP-FPM
COPY php-fpm.conf /usr/local/etc/php-fpm.d/www.conf

# Expose port 9000
EXPOSE 9000

# Command to run the background worker
CMD ["php", "artisan", "queue:work", "--sleep=3", "--tries=3"]
