# Use the official PHP runtime as the parent image
FROM php:8.1-fpm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install

# Copy Laravel configuration file
COPY .env.example .env

# Configure PHP settings
RUN php artisan key:generate

# Create a directory for the queue
RUN mkdir -p storage/framework/queues

# Expose the default PHP port
EXPOSE 9000

# Run artisan queue:work command to start the queue worker
CMD ["php", "artisan", "queue:work", "--queue=laravel"]
