# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip \
    git \
    cron

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy existing application directory contents
COPY . .

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Setup cron job for Laravel Task Scheduler
RUN echo "* * * * * root php /var/www/html/artisan schedule:run >> /dev/null 2>&1" > /etc/cron.d/laravel-schedule
RUN chmod 0644 /etc/cron.d/laravel-schedule

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
