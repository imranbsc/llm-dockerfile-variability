# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Set the working directory in the container
WORKDIR /app

# Copy the compiled Java application jar to the container
COPY target/your-application.jar /app/your-application.jar

# Expose the application port if needed
# EXPOSE 8080

# Define the entrypoint command to run the application
ENTRYPOINT ["java", "-jar", "your-application.jar"]
