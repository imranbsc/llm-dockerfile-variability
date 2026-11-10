# Use the official PHP image from the Docker Hub
FROM php:8.1-apache

# Set the working directory
WORKDIR /var/www/html

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libpq-dev \
    libzip-dev \
    unzip \
    curl \
    git \
    && docker-php-ext-configure gd \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Laravel dependencies
RUN composer install --no-dev

# Run Laravel's built-in server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
