# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install

# Expose the default HTTP port
EXPOSE 9000

# Make port 9000 available to the world outside this container
VOLUME /var/www/html/storage/app/public

# Define environment variables
ENV NAME World

# Run your app
CMD ["php", "artisan", "serve"]
