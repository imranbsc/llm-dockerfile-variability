# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the local code to the container image
COPY . .

# Install system dependencies
RUN apk add --no-cache \
    git \
    unzip \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    redis \
    supervisor

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'e21205b207c3ff031906575712edab6f13eb0b361f2085f1f1237b7126d785e826a450292b6cfd1d64d95d6d75f873c' && file_exists('/usr/local/bin/composer')) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Install Laravel dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Configure Redis client
RUN pecl install redis && docker-php-ext-enable redis

# Configure Supervisor
COPY supervisor.conf /etc/supervisord/conf.d/supervisor.conf

# Command to run Supervisor
CMD ["supervisord", "-n"]
