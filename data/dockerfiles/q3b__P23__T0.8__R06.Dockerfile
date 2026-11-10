# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    libzip-dev \
    libpng-dev \
    zlib1g-dev \
    git \
    libpq-dev \
    libxml2-dev \
    && docker-php-ext-install zip gd xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Run Composer install
RUN composer install --no-dev --prefer-dist

# Copy the database configuration file to the container
COPY .env /var/www/html/.env

# Create a symbolic link for the database
RUN ln -s /var/www/html/storage/database.sqlite /var/www/html/database.sqlite

# Expose the default PHP port
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
