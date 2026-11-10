# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

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

# Create app directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Build the application (if applicable)
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
