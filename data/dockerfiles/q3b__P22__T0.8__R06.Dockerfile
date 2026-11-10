# Use an official PHP runtime as a parent image
FROM php:8.1-fpm-alpine

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the package.json file to the container
COPY package.json /var/www/html/package.json

# Install any needed packages specified in package.json
RUN apk add --no-cache --virtual .build-deps \
    php-dev \
    build-base \
    curl \
    curl-dev \
    git \
    libzip-dev \
    zip \
    && npm install -g yarn \
    && yarn install --production \
    && apk del .build-deps

# Copy the rest of the application files to the container
COPY . /var/www/html

# Copy the .env.example file to .env if it doesn't exist
RUN [ ! -f .env ] && cp .env.example .env

# Run the artisan command to install the dependencies
RUN composer install --no-dev

# Set the environment variable for the database
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysql
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=laravel
ENV DB_PASSWORD=laravel

# Run the artisan command to migrate the database
RUN php artisan migrate

# Expose the port the application will run on
EXPOSE 80

# Start the PHP-FPM service
CMD ["php-fpm"]
