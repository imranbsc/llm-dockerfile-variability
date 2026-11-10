# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo_mysql

# Set working directory in the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock files
COPY composer.json composer.lock ./

# Install dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy the rest of the application code
COPY . .

# Expose the application port
EXPOSE 9000

# Command to run the application
CMD ["php-fpm"]
