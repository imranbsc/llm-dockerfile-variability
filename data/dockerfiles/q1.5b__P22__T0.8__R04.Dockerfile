# Use a pre-built PHP image as the base image
FROM php:8.2-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in composer.json
RUN composer install

# Expose the port Laravel is listening on
EXPOSE 80

# CMD command to run the Laravel server
CMD ["php", "artisan", "serve"]
