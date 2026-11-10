# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_KEY=base64:your-app-key

# Copy the Laravel task scheduler cron job
COPY crontab /etc/cron.d/laravel-scheduler

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/laravel-scheduler

# Create the log file to avoid permission issues
RUN touch /var/www/html/storage/logs/laravel.log

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
