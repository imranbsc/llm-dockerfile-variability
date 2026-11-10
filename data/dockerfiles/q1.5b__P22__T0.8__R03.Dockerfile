# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
# RUN chown -R www-data:www-data /var/www/html
# RUN composer install

# Expose the default port for PHP-FPM
EXPOSE 9000

# Define environment variable
ENV NAME World

# Run app on the command line
CMD ["php-fpm"]
