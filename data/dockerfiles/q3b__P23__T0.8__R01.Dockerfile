# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install

# Create a directory for the queue database
RUN mkdir -p storage/framework/queues

# Copy Supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the run script
COPY run.sh /run.sh

# Make the run script executable
RUN chmod +x /run.sh

# Define environment variables
ENV DB_HOST db
ENV DB_DATABASE your_database
ENV DB_USERNAME your_username
ENV DB_PASSWORD your_password

# Expose the default port
EXPOSE 80

# Start Supervisor
CMD ["supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
