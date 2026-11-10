# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set environment variables
ENV PHP_DEBIAN_PRIORITY=high

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application source code
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose port 9000
EXPOSE 9000
