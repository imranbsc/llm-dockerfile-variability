# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the project using Maven
RUN ./mvnw clean install

# Expose the port that your application runs on
EXPOSE 8080

# Command to run your Spring Boot application
CMD ["java", "-jar", "target/your-spring-boot-app.jar", "--spring.rabbitmq.host=rabbitmq"]
