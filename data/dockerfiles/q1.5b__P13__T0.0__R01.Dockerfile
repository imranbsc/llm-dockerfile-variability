# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in package.json
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the app when the container launches
CMD ["java", "-jar", "target/your-spring-boot-app.jar"]
