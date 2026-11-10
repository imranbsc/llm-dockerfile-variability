# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy local code to the container image
COPY . /var/www/html

# Install PHP extensions required by Laravel
RUN docker-php-ext-install pdo_mysql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install --optimize-autoloader --no-dev

# Set up the Laravel scheduler
RUN (crontab -l 2>/dev/null; echo "* * * * * php /var/www/html/artisan schedule:run >> /dev/null 2>&1") | crontab -

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
