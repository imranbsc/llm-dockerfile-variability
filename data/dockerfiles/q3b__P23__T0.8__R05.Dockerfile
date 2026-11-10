# Use the official PHP image from Docker Hub
FROM php:8.1-fpm

# Install necessary packages
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the current directory contents into the container at /var/www/html
WORKDIR /var/www/html

# Copy the project into the container
COPY . /var/www/html

# Install project dependencies
RUN composer install --no-dev

# Set environment variables
ENV APP_ENV=production
ENV QUEUE_CONNECTION=database
ENV QUEUE_DISPATCH_LIMIT=500
ENV QUEUE_TTL=60

# Define environment variable for database connection
ENV DB_CONNECTION=mysql
ENV DB_HOST=database
ENV DB_PORT=3306
ENV DB_DATABASE=laravel_queue
ENV DB_USERNAME=your_database_user
ENV DB_PASSWORD=your_database_password

# Define environment variable for mail configuration
ENV MAIL_HOST=smtp.example.com
ENV MAIL_PORT=587
ENV MAIL_USERNAME=your_email@example.com
ENV MAIL_PASSWORD=your_email_password
ENV MAIL_ENCRYPTION=tls

# Expose port 9000 for the FPM server
EXPOSE 9000

# Start the FPM server
CMD ["php-fpm"]
