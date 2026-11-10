# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libzip-dev \
    && docker-php-ext-install pdo_mysql zip pdo_pgsql

# Copy the local code to the container at /var/www/html
COPY . /var/www/html

# Set the working directory in the container
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Run Composer install
RUN composer install

# Install Laravel dependencies
RUN php artisan config:cache && php artisan route:cache && php artisan view:cache

# Expose the default Laravel port
EXPOSE 80

# Define environment variable for Laravel configuration
ENV APP_ENV=production

# Set the command to run the worker process
CMD ["php", "artisan", "queue:work"]
