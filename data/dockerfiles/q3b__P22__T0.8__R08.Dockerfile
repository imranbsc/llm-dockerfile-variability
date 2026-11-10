# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libzip-dev \
    && docker-php-ext-install zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install Laravel
RUN composer global require laravel/installer

# Create a symbolic link to the Laravel global binaries
RUN ln -s /usr/local/bin/laravel /usr/bin/laravel

# Copy the .env file from the host to the container
COPY .env.example .env

# Install application dependencies
RUN composer install --no-dev --optimize-autoloader

# Expose the port that Nginx will listen on
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
