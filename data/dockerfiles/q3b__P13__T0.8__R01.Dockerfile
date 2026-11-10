# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 5672 available to the world outside this container for RabbitMQ
EXPOSE 5672

# Define environment variable
ENV SPRING_PROFILES_ACTIVE=worker

# Add RabbitMQ connection properties if needed
ENV RABBITMQ_URL=amqp://guest:guest@rabbitmq:5672/

# Run the application using the Spring Boot executable
ENTRYPOINT ["java", "-jar", "target/your-application.jar"]
