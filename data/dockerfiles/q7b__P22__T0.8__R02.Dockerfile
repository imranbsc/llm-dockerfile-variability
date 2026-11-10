# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_URL=http://localhost

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy existing application directory contents
COPY . /var/www/html

# Install application dependencies
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Build application assets
RUN npm install && npm run production

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
