# Use a PHP:7.4-fpm image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock files to the container
COPY composer.json composer.lock ./

# Install the dependencies using Composer
RUN composer install --optimize-autoloader --no-dev

# Copy the rest of the files in the container
COPY . .

# Expose the default HTTP port
EXPOSE 80

# Run the command to clear the Symfony cache
CMD ["php", "./bin/console", "cache:clear"]
