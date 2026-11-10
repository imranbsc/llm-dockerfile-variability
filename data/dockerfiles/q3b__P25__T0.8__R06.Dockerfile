# Use the official PHP image from the Docker Hub
FROM php:7.4-cli

# Set the timezone to Europe/London
ENV TZ=Europe/London

# Install necessary packages
RUN apt-get update && apt-get install -y \
    cron \
    supervisor \
    git \
    curl \
    libpq-dev \
    && docker-php-ext-install pdo_mysql

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install --no-dev

# Configure Laravel to use the task scheduler
RUN cp .env.example .env

# Run the Laravel key generation command
RUN php artisan key:generate

# Set up the crontab to run the scheduled task
RUN crontab -e
# Add a line to the crontab to run the scheduled task at 12:00 AM every day
# * * * * * /usr/local/bin/php /app/artisan schedule:run >> /app/cron.log 2>&1

# Expose port 9000 for PHP-FPM
EXPOSE 9000

# Start supervisor to manage the cron daemon
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
