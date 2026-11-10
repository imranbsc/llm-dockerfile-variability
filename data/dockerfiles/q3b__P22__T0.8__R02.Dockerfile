# Use the official PHP runtime as a parent image
FROM php:8.2-apache

# Set the working directory in the container
WORKDIR /var/www/html

# Install additional dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libpq-dev \
    git \
    libzip-dev && \
    docker-php-ext-configure gd --with-freetype && \
    docker-php-ext-install pdo pdo_mysql gd zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer install

# Expose the default port for Apache
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
