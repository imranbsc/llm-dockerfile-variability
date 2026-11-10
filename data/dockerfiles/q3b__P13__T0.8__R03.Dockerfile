# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file to the container
COPY target/your-spring-boot-app.jar app.jar

# Expose the port that the Spring Boot application listens on
EXPOSE 8080

# Set the environment variable for RabbitMQ connection details
ENV RABBITMQ_URL amqp://guest:guest@rabbitmq:5672/

# Command to run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
