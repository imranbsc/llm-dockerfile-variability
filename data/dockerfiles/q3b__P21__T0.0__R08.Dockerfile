# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Laravel dependencies
RUN composer install

# Expose the default port for Laravel
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
