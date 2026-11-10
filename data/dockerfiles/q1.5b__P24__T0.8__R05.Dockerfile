# Use a recent PHP 7.4 image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any required packages specified in composer.json
RUN composer install --no-scripts

# Define environment variables
ENV APP_ENV dev

# Set the default command to run the application
CMD ["php", "bin/console"]
