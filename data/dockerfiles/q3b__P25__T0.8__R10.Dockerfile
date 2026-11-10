# Use the official PHP image from Docker Hub
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer create-project --prefer-dist laravel/laravel .

# Set environment variables for Laravel
ENV APP_KEY=your_app_key_here
ENV DB_HOST=your_database_host
ENV DB_DATABASE=your_database_name
ENV DB_USERNAME=your_database_user
ENV DB_PASSWORD=your_database_password

# Expose the default PHP port
EXPOSE 9000

# Start the PHP-FPM server
CMD ["php-fpm"]
