# Use the official PHP runtime image from Docker Hub
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_mysql pdo

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Run Composer to install dependencies
RUN composer install

# Copy the entrypoint script to the container
COPY entrypoint.sh /usr/local/bin/

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/entrypoint.sh

# Define environment variable
ENV APP_ENV production

# Make port 9000 available to the world outside this container
EXPOSE 9000

# Run the entrypoint script
ENTRYPOINT ["./entrypoint.sh"]
