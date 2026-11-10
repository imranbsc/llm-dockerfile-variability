# Use an official PHP runtime as a parent image
FROM php:8.1-cli

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libpq-dev \
    git \
    zip \
    && docker-php-ext-install pdo pdo_mysql

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies from composer.json
RUN composer install --no-dev

# Expose the default port for PHP applications
EXPOSE 8080

# Run the application
CMD ["php", "artisan", "serve", "--host=0.0.0.0"]
