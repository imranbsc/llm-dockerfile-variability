# Use the official PHP:7.4-fpm image as the base image
FROM php:7.4-fpm

# Set the working directory in the container to /var/www/html
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in composer.json
RUN composer install --no-dev

# Generate the authentication key for Laravel
RUN php artisan key:generate

# Set the environment variables for the application
ENV APP_ENV development
ENV APP_DEBUG true
ENV APP_URL http://localhost

# Expose the port that the PHP-FPM service is listening on
EXPOSE 9000

# Run the artisan serve command to start the server
CMD ["php", "artisan", "serve"]
