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
RUN composer install --no-dev

# Copy the .env file to the container
COPY .env.example .env

# Copy the database configuration file to the container
COPY .env.database .env.database

# Copy the database migrations to the container
COPY database/migrations/ database/migrations/

# Run database migrations
RUN php artisan migrate

# Copy the storage directory to the container
COPY --from=0 /var/www/html/storage/storage /var/www/html/storage/storage

# Copy the public directory to the container
COPY --from=0 /var/www/html/public/public /var/www/html/public/public

# Expose the default port for Laravel
EXPOSE 80

# Run the artisan queue:work command to start the worker
CMD ["php", "artisan", "queue:work"]
