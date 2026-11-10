# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies using Composer
RUN apk add --no-cache curl git
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install

# Install NPM dependencies
RUN apk add --no-cache npm
RUN npm install

# Expose the default port for Laravel (8000)
EXPOSE 8000

# Start the PHP-FPM service
CMD ["php-fpm"]
