# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the composer.json and composer.lock file to the working directory
COPY composer.json composer.lock ./

# Install any needed packages specified in the composer.json file
RUN composer install --no-dev

# Copy the rest of the application files into the working directory
COPY . .

# Define environment variable for the app
ENV APP_ENV=production

# Define the command to run the Laravel queue worker
CMD ["php", "artisan", "queue:work", "--daemon"]
