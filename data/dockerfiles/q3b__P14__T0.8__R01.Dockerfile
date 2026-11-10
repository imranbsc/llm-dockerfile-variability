# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV PORT 8080

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application using picocli
CMD ["java", "-jar", "your-tool.jar"]
