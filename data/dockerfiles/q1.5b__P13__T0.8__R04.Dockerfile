# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    spring-boot-maven-plugin \
    rabbitmq-client \
    && rm -rf /var/lib/apt/lists/*

# Set the environment variable for the application
ENV SPRING_APPLICATION_NAME=my-spring-boot-app

# Run the Spring Boot application
CMD ["java", "-jar", "target/my-spring-boot-app.jar"]
