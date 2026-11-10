# Use an official PHP runtime as a parent image
FROM php:7.4-cli

# Install Symfony Console globally
RUN composer global require symfony/console

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Set permissions for the command-line tool
RUN chmod +x /app/bin/your-tool.php

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run your command-line tool when the container launches
CMD ["php", "/app/bin/your-tool.php"]
