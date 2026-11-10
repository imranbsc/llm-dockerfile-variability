# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install --no-dev

# Expose the default web port
EXPOSE 9000

# Define environment variable
ENV NAME World

# Run app when the container launches
CMD ["php", "bin/console", "serve:web"]
