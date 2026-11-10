# Use an official PHP runtime as a parent image
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install any needed packages specified in requirements.txt
COPY composer.lock composer.json /var/www/html/
RUN composer install --no-dev

# Copy the rest of the application code
COPY . /var/www/html

# Install additional dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Copy the cron script to the container
COPY cron.sh /etc/cron.d/cronjob

# Configure cron to run the job at the specified interval
RUN crontab -e
# Add your cron job here, e.g., */5 * * * * /usr/bin/php /var/www/html/artisan schedule:run

# Expose the default PHP port
EXPOSE 9000

# Start the PHP-FPM service
CMD ["php-fpm"]
