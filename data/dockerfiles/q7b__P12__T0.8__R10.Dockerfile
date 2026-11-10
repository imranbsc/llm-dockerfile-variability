# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the jar file into the container
COPY target/your-application-name.jar /app/your-application-name.jar

# Expose the port the application runs on
EXPOSE 8080

# Run the application when the container launches
ENTRYPOINT ["java", "-jar", "your-application-name.jar"]
