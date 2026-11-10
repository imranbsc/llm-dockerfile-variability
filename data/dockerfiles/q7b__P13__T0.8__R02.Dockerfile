# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Spring Boot application jar and the rabbitmq client jar into the container
COPY target/your-application.jar /app/your-application.jar
COPY target/rabbitmq-client.jar /app/rabbitmq-client.jar

# Expose the port your application is listening on
EXPOSE 8080

# Command to run your application using Java
CMD ["java", "-jar", "your-application.jar"]
