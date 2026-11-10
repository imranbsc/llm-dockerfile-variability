# Use an official PHP runtime as a parent image
FROM php:8.1-cli

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y --no-cache git unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer install

# Install Laravel task scheduler
RUN composer require symfony/stopwatch

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV APP_ENV=production

# Run the command to start Laravel's scheduler
CMD ["php", "artisan", "schedule:run"]
