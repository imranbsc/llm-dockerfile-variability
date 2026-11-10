# Use an official PHP runtime as a parent image
FROM php:7.4-cli-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in composer.json
RUN apk add --no-cache --virtual .build-deps \
        git && \
    apk add --no-cache \
        composer && \
    composer install && \
    apk del .build-deps

# Run the application
CMD ["php", "bin/console", "your-command"]
