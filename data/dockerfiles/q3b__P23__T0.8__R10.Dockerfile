# Use the official PHP image as the base image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install

# Expose the default PHP FPM port
EXPOSE 9000

# Set environment variables for Laravel
ENV APP_KEY=your-secret-key
ENV QUEUE_CONNECTION=redis

# Run the Laravel worker command
CMD ["php", "artisan", "queue:work"]
