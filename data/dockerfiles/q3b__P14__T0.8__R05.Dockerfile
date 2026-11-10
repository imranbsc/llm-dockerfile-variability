# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file from the build directory to the container
COPY target/your-tool-1.0.0-SNAPSHOT.jar app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV APP_PORT 8080

# Define command to run the application
CMD ["java", "-jar", "app.jar"]
