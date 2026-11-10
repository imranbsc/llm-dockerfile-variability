# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install

# Install php artisan schedule job
RUN php artisan schedule:run

# Define environment variables
ENV APP_ENV=production

# Define the command to run when the container launches
CMD ["php", "artisan", "schedule:run"]
