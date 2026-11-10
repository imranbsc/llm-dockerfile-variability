# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application files
COPY . /var/www/html

# Install application dependencies
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Copy Laravel scheduler cron job
COPY crontab /etc/cron.d/laravel-scheduler

# Give permission to laravel scheduler cron job
RUN chmod 0644 /etc/cron.d/laravel-scheduler

# Run cron job
RUN crontab /etc/cron.d/laravel-scheduler

# Expose the port the web server is listening on
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
