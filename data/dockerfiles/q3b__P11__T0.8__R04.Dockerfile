# Use an official OpenJDK runtime as a parent image
FROM openjdk:8-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 8443 available to the world outside this container
EXPOSE 8443

# Define environment variable
ENV SPRING_APPLICATION_NAME=myapp

# Run the application using the entrypoint
CMD ["java", "-jar", "myapp.jar"]
