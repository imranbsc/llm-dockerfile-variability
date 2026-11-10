# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_URL=http://localhost

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

# Create the application directory
WORKDIR /var/www/html

# Copy the application code
COPY . .

# Install the dependencies
RUN composer install --no-dev --optimize-autoloader

# Build the application
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
