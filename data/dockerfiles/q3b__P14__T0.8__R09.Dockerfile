# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the packaged application JAR to the container
COPY target/your-application.jar /app/app.jar

# Expose the default port your application is running on
EXPOSE 8080

# Define environment variables if needed

# Run the application
CMD ["java", "-jar", "app.jar"]
