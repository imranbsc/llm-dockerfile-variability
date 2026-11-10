# Use an official OpenJDK runtime as a parent image
FROM openjdk:8-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 5672 available to the world outside this container
EXPOSE 5672

# Define environment variable
ENV RABBITMQ_HOST rabbitmq

# Run the application using the executable
ENTRYPOINT ["java", "-jar", "target/your-application.jar"]
