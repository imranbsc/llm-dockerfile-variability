# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    git \
    && docker-php-ext-install zip gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer install

# Run Migrations to create the database schema
RUN php artisan migrate

# Expose the default Laravel port
EXPOSE 80

# Start the PHP-FPM service
CMD ["php-fpm"]
