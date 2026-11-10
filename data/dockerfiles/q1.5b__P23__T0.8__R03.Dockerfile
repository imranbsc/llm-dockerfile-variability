# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install --optimize-autoloader

# Define environment variable
ENV NAME World

# Run composer install if any files changed in the last 20 minutes
RUN composer install --optimize-autoloader --ignore-platform-gateways --prefer-dist --force

# Make port 9000 available to the world outside this container
EXPOSE 9000

# Define environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Set the command to run when the container launches
CMD ["php", "-S", "0.0.0.0:9000", "artisan", "queue:work"]
