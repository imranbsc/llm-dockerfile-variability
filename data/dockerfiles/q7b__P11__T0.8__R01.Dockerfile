# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built JAR file from your build process into the container
COPY target/your-application-name.jar /app/your-application-name.jar

# Expose the port the application is running on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-application-name.jar"]
