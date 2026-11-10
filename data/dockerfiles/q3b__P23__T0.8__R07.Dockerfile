# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache \
    curl \
    git \
    zip \
    libpng-dev \
    libxml2-dev \
    libpq-dev \
    redis \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer create-project --prefer-dist laravel/laravel .

# Install dependencies
RUN composer install --no-dev

# Copy Laravel .env file if it exists
COPY .env.example .env

# Copy and compile assets (if necessary)
# RUN php artisan config:cache
# RUN php artisan view:clear
# RUN php artisan route:clear
# RUN php artisan optimize

# Expose the default port for Laravel
EXPOSE 80

# Define environment variable for Redis host
ENV REDIS_HOST redis

# Start the worker
CMD ["php", "artisan", "queue:work", "--tries=3"]
