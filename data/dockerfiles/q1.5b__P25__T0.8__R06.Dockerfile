# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install --optimize-autoloader

# Expose the default Laravel port
EXPOSE 80

# Define environment variable
ENV APP_ENV development

# Set the command to run the scheduled tasks
CMD ["/usr/local/bin/php", "artisan", "schedule:run"]
