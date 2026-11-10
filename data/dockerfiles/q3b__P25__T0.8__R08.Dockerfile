# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . .

# Install any needed packages specified in composer.json
RUN composer install --no-dev --optimize-autoloader

# Install Laravel and its dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy the .env.example file to .env for development
COPY .env.example .env

# Copy the database configuration files
COPY database/database.sqlite .database/database.sqlite

# Set environment variables
ENV DB_CONNECTION sqlite
ENV DB_DATABASE database.sqlite

# Run artisan migrate to create tables
RUN php artisan migrate

# Start the PHP-FPM server
CMD ["php-fpm"]

# Configure the task scheduler
RUN composer require --dev phpunit/phpunit

# Add a cron job to run the task scheduler
RUN echo "* * * * * php artisan schedule:run >> /dev/null 2>&1" >> /etc/crontab

# Set the cron service to run daily
RUN service cron start && crontab -l >> /etc/crontab && cron -l
