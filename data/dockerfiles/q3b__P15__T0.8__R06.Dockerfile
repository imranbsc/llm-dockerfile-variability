# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file from your local machine to the container
COPY target/your-application.jar your-application.jar

# Expose the port on which your Spring Batch job will run
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-application.jar"]
