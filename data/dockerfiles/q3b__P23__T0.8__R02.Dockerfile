# Use an official PHP runtime as a parent image
FROM php:8.0-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y libpq-dev && \
    docker-php-ext-install pdo_pgsql

# Copy the Composer file and install dependencies
COPY composer.lock composer.json ./
RUN composer install --no-dev --no-scripts

# Copy the rest of the application code
COPY . .

# Install node modules
RUN npm install

# Build the application for production
RUN npm run build

# Expose the default port for Laravel
EXPOSE 80

# Run the Laravel queue worker
CMD ["php", "artisan", "queue:work", "--daemon"]
