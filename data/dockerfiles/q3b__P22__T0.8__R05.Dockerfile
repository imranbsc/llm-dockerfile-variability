# Use an official PHP runtime as a parent image
FROM php:7.4-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libzip-dev \
    zlib1g-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    libmcrypt-dev \
    git \
    curl \
    unzip \
    && docker-php-ext-configure zip \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) pdo_pgsql \
    && docker-php-ext-install -j$(nproc) mbstring \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) opcache \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Run Composer install
RUN composer install --no-dev

# Install Node.js and npm (optional if you need front-end dependencies)
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install yarn (optional if you need front-end dependencies)
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

# Set environment variables
ENV APP_ENV=production
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysql
ENV DB_PORT=3306
ENV DB_DATABASE=laravel
ENV DB_USERNAME=your_username
ENV DB_PASSWORD=your_password

# Expose the port on which Laravel is served
EXPOSE 80

# Define working directory
WORKDIR /var/www/html

# Start the PHP-FPM server
CMD ["php-fpm"]
