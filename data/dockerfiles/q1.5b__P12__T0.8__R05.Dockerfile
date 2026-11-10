# Use an official openjdk runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache \
    && apk add --no-cache tzdata \
    && rm -rf /var/cache/apk/*

# Expose the application port
EXPOSE 8080

# Run the app using the Spring Boot executable
CMD ["java", "-jar", "target/your-spring-boot-app.jar"]
