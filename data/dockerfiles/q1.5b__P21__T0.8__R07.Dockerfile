# Use an official PHP image as the base image
FROM php:7.4-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the PHP application files to the container
COPY . /var/www/html

# Install any required packages
RUN composer install

# Expose the default HTTP port
EXPOSE 80

# Define the command to run the application
CMD ["php", "-S", "0.0.0.0:80"]
