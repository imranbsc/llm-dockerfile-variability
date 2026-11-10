# Use an official openjdk runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the app using the Spring Boot executable
CMD ["java", "-jar", "target/*.jar"]
