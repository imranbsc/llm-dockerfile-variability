# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Run Composer install
RUN composer install

# Copy the Nginx configuration file to the container
COPY nginx/default.conf /etc/nginx/sites-available/default

# Copy the Supervisor configuration file to the container
COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Start Nginx and Supervisor
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
