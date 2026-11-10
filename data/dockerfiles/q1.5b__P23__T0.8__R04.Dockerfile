# Use a stable PHP image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock files from the host to the container
COPY composer.json composer.lock ./

# Install dependencies using Composer
RUN composer install --prefer-dist --optimize-autoloader

# Copy the application files from the host to the container
COPY . .

# Set the environment variables
ENV APP_ENV development

# Expose the default port for PHP-FPM
EXPOSE 9000

# Start the Laravel queue worker
CMD ["php artisan", "queue:work"]
