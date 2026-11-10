# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary extensions
RUN docker-php-ext-install pdo_mysql

# Copy the application code into the container
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose the port that Laravel will use
EXPOSE 9000

# Command to run Laravel's scheduler
CMD ["php", "artisan", "schedule:run"]
