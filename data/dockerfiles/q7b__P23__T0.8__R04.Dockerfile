FROM php:8.1-fpm

# Set environment variables
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV APP_KEY=base64:YOUR_APP_KEY
ENV QUEUE_CONNECTION=redis
ENV REDIS_HOST=redis
ENV REDIS_PASSWORD=your_redis_password

# Install dependencies
RUN apt-get update && apt-get install -y libpng-dev libonig-dev libxml2-dev zip unzip && \
    docker-php-ext-install pdo_mysql mbstring gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy application code
COPY . /var/www/html

# Install application dependencies
WORKDIR /var/www/html
RUN composer install --no-dev --optimize-autoloader

# Set working directory
WORKDIR /var/www/html/bootstrap/cache

# Generate application key
RUN php artisan key:generate

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# Set CMD
CMD ["php", "artisan", "queue:work"]
