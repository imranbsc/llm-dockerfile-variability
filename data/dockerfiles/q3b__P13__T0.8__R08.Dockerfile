# Use an official OpenJDK 11 base image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container
COPY target/your-application.jar your-application.jar

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-application.jar"]
