# Use the official PHP image as the base image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies using Composer
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libpng-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libwebp-dev \
    libpq-dev \
    libxml2-dev \
    unzip \
    git && \
    docker-php-ext-configure zip && \
    docker-php-ext-configure gd && \
    docker-php-ext-configure pdo_pgsql && \
    docker-php-ext-install zip gd pdo_pgsql && \
    pecl install -y xdebug && \
    docker-php-ext-enable xdebug && \
    rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install application dependencies
RUN composer install

# Run the application
CMD ["php", "bin/console"]
