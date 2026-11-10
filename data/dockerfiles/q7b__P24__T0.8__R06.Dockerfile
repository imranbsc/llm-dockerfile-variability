# Use an official PHP runtime as a parent image
FROM php:8.1-cli

# Set the working directory in the container
WORKDIR /app

# Install required system packages
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libfreetype6-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    locales \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd mbstring intl opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy project files into the container
COPY . /app

# Install project dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Make the entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Set the default command
ENTRYPOINT ["/app/entrypoint.sh"]
