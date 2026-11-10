# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the local code to the container at /app
COPY target/your-application-name.jar /app/your-application-name.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV RABBITMQ_URI amqp://guest:guest@rabbitmq:5672/

# Run the application
ENTRYPOINT ["java", "-jar", "your-application-name.jar"]
