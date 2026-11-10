# Use a PHP image as the base image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the Composer configuration and dependencies
COPY composer.json ./
COPY composer.lock ./

# Install dependencies
RUN composer install --prefer-dist --no-dev

# Copy the application code into the container
COPY . .

# Run the Laravel artisan console command to migrate the database
CMD ["php", "artisan", "migrate"]
