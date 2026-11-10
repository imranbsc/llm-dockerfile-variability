# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    locales \
    && docker-php-ext-install pdo_mysql mbstring pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . .

# Install dependencies
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Run database migrations
RUN php artisan migrate --force

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
