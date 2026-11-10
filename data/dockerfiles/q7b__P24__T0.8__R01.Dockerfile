# Use an official PHP runtime as a parent image
FROM php:8.2-cli

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    && docker-php-ext-install -j$(nproc) gd zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the project files into the container
COPY . /app

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Set the command to run the Symfony Console tool
CMD ["php", "bin/console"]
