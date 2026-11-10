# Use an official PHP runtime as a parent image
FROM php:8.1-cli

# Set the working directory in the container
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    libpng-dev \
    libonig-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring gd

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
COPY . .

# Install project dependencies
RUN composer install --optimize-autoloader --no-dev

# Expose port 22 for SSH (if needed)
EXPOSE 22

# Define environment variable
ENV APP_ENV production

# Make port 22 accessible to the world outside this container
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Make port 80 available to the world outside this container
EXPOSE 80

# Define command to run your PHP application
CMD ["php", "-S", "0.0.0.0:80"]
