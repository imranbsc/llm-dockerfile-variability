# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in composer.json
RUN apt-get update && apt-get install -y \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libpq-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 \
    && docker-php-ext-install gd \
    && docker-php-ext-install zip \
    && docker-php-ext-install opcache \
    && docker-php-ext-install pcntl \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install exif \
    && docker-php-ext-install gd \
    && docker-php-ext-install gmp \
    && docker-php-ext-install intl \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && docker-php-ext-install sodium \
    && docker-php-ext-install xml

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel dependencies
RUN composer install --no-dev

# Copy the Laravel `.env` file if it exists
COPY .env /var/www/html/.env

# Copy the Laravel `database` directory if it exists
COPY database /var/www/html/database

# Expose the default port for Laravel's Artisan commands
EXPOSE 9000

# Run the artisan command to optimize the application
CMD ["php", "artisan", "optimize"]

# Run the artisan command to queue workers
CMD ["php", "artisan", "queue:work"]
