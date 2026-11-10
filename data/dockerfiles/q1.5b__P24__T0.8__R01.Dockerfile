# Use an official PHP image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in composer.json
RUN composer install --optimize-autoloader

# Expose the default port for PHP-FPM
EXPOSE 9000

# Define environment variable
ENV APP_ENV prod

# Define the command to run when the container launches
CMD ["php", "bin/console", "serve:webserver"]
