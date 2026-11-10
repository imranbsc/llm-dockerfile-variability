# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apk update && \
    apk add --no-cache \
        postgresql-client \
        libpq \
        curl \
        git \
        zip \
        unzip \
        && docker-php-ext-install pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install --no-dev

# Install Laravel scheduler
RUN php artisan schedule:install

# Copy the cron file to the container
COPY cron/cron.php /etc/cron.d/laravel
RUN chmod 0644 /etc/cron.d/laravel

# Set the cron to run every minute
RUN crontab /etc/cron.d/laravel

# Expose the port that Laravel is listening on
EXPOSE 9000

# Start the PHP-FPM service
CMD ["php-fpm"]
