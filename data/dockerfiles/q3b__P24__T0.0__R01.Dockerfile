# Use an official PHP runtime as a parent image
FROM php:7.4-cli

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN composer install

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV APP_ENV=production

# Run the application
CMD ["php", "bin/console", "app:run"]
