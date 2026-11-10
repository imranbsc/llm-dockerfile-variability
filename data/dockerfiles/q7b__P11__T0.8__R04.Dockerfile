# Use an official openjdk runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Add the compiled JAR file to the container
COPY target/your-application.jar /app/your-application.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-application.jar"]
