# Use an official PHP runtime as a parent image
FROM php:7.4-cli

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y --no-cache \
    git \
    curl \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    libxml2-dev \
    libcurl4-openssl-dev

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dependencies
RUN composer install

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV APP_ENV=prod

# Run your application
CMD ["php", "bin/console"]
