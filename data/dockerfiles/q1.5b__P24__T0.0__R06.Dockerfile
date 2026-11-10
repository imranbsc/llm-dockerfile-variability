# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install --optimize-autoloader

# Expose the default HTTP port
EXPOSE 80

# Define environment variables
ENV APP_ENV=dev

# Run the command to start the PHP-FPM service
CMD ["php-fpm"]
