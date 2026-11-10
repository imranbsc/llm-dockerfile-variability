# Use an official OpenJDK image from the Docker Hub
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the local directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run your application
CMD ["java", "-jar", "your-application.jar"]
