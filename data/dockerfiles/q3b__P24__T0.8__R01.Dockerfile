# Use an official PHP runtime as a parent image
FROM php:7.4-cli

# Set the working directory in the container
WORKDIR /usr/src/app

# Install any needed packages specified in requirements.txt
COPY requirements.txt .
RUN composer install

# Copy the rest of the application code
COPY . .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application
CMD ["php", "bin/console", "app:command"]
