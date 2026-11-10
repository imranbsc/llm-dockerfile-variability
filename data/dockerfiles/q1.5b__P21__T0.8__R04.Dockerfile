# Use the official PHP image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock files from the current directory to the working directory in the container
COPY composer.json composer.lock ./

# Install any dependencies using Composer
RUN composer install --optimize-autoloader

# Copy the rest of the files from the current directory to the working directory in the container
COPY . .

# Expose the default port for PHP-FPM
EXPOSE 9000

# Run the command to start the PHP-FPM service
CMD ["php-fpm"]
