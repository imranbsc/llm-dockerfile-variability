# Use an official Java runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the jar file when the container launches
CMD ["java", "-cp", "picocli-4.7.0.jar:.", "com.example.MyApplication"]
