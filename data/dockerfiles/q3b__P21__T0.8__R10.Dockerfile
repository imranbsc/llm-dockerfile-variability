# Use the official PHP image from the Docker Hub
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libldap2-dev \
    libpq-dev \
    zlib1g-dev \
    && docker-php-ext-install -j$(nproc) zip pdo_mysql gd mbstring bcmath exif pcntl intl

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the composer.lock and composer.json files to the container
COPY composer.lock composer.json ./

# Install dependencies
RUN composer install --no-dev --optimize-autoloader

# Copy the rest of the Laravel application to the container
COPY . .

# Set environment variables for Laravel
ENV APP_ENV=local
ENV DB_CONNECTION=mysql
ENV DB_HOST=db
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=laravel
ENV DB_PASSWORD=secret

# Expose the port that Laravel expects for its web server
EXPOSE 80

# Start the PHP-FPM service
CMD ["php-fpm"]
