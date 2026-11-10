# Use an official Java runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the jar file into the container
COPY target/my-spring-boot-app.jar /app/my-spring-boot-app.jar

# Define the command to run the application
CMD ["java", "-jar", "my-spring-boot-app.jar"]
