# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false

# Install dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    && docker-php-ext-install zip pdo pdo_mysql

# Copy existing application directory contents
WORKDIR /var/www/html

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install project dependencies
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Copy project files
COPY . .

# Build assets (if any)
RUN npm install
RUN npm run production

# Expose port 9000 and start PHP-FPM server
EXPOSE 9000
CMD ["php-fpm"]
