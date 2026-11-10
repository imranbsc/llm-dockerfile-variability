# Use the official PHP image from the Docker Hub
FROM php:8.1-fpm

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . /var/www/html

# Install any needed packages specified in requirements.txt
RUN composer install

# Install the Laravel queue worker
RUN composer require laravel/framework:^8.0

# Copy the .env file to the container
COPY .env.example .env

# Set environment variables
ENV DB_CONNECTION=mysql
ENV DB_HOST=mysql
ENV DB_DATABASE=your_database
ENV DB_USERNAME=your_username
ENV DB_PASSWORD=your_password

# Run the Laravel queue worker
CMD ["php artisan queue:work --queue=default,other_queue"]
