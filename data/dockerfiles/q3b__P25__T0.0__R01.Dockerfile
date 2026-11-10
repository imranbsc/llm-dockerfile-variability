# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install

# Copy the .env file to the container
COPY .env.example .env

# Copy the database configuration file to the container
COPY .env.database.example .env.database

# Copy the database dump file to the container
COPY database.sql database.sql

# Run the database migrations
RUN php artisan migrate

# Expose the default port for Laravel
EXPOSE 80

# Run the Laravel development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0"]
