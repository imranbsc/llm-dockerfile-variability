# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
COPY composer.lock composer.json /var/www/html/
RUN composer install --no-interaction

# Install all production dependencies (optional)
RUN composer install --no-interaction --no-dev

# Copy the local code to the container at /var/www/html
COPY . /var/www/html

# Make port 80 available to the world outside this container
EXPOSE 80

# Run PHP-FPM
CMD ["php-fpm"]
