# Use a base PHP image
FROM php:8.0-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
COPY composer.json .
COPY composer.lock .
RUN composer install --no-dev

# Copy the rest of the project files
COPY . .

# Expose the default HTTP port
EXPOSE 9000

# Start the PHP-FPM service
CMD ["php-fpm"]
