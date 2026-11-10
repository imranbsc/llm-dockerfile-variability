# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install

# Expose the default HTTP port
EXPOSE 80

# Define environment variables
ENV APP_ENV=development

# Set the command to run when the container launches
CMD ["php", "artisan", "serve"]
