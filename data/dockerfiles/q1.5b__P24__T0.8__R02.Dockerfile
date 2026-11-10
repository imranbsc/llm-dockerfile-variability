# Use a base PHP image
FROM php:8.0-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Install any required dependencies
RUN composer install --optimize-autoloader

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Define environment variable
ENV APP_ENV dev

# Expose the default console port
EXPOSE 9000

# Define the command to run
CMD ["php", "./bin/console"]
