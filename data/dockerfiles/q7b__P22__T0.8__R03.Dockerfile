# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV production
ENV APP_DEBUG false

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create directory structure
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy .env file and generate key
COPY .env.example .env
RUN php artisan key:generate

# Expose port
EXPOSE 9000

# Command to run the application
CMD ["php-fpm"]
