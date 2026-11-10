# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    && \
    composer install && \
    rm -rf /var/lib/apt/lists/*

# Expose the web port
EXPOSE 9000

# Define environment variable
ENV APP_ENV=development

# CMD ["/usr/bin/php", "artisan", "serve"]
CMD ["php", "-S", "0.0.0.0:9000", "-t", "public"]
