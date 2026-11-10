# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

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
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy queue worker script
COPY queue-worker.sh /usr/local/bin/queue-worker.sh
RUN chmod +x /usr/local/bin/queue-worker.sh

# Expose port 9000 and start PHP-FPM server
CMD ["php-fpm"]
