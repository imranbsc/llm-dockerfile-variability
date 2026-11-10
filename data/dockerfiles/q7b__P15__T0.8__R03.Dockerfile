# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the local src directory contents into the container at /app
COPY target/spring-batch-job-*.jar app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application using the java command
CMD ["java", "-jar", "app.jar"]
