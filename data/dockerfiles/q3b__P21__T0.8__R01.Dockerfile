# Use the official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV APP_ENV=local

# Start Laravel development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0"]
