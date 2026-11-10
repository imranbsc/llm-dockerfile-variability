# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install --optimize-autoloader

# Run the artisan schedule:run command to execute scheduled jobs
CMD ["php", "artisan", "schedule:run"]
