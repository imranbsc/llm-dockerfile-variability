# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application jar into the container
COPY target/your-application.jar /app/your-application.jar

# Expose the port the application will run on
EXPOSE 8080

# Define environment variables
ENV SPRING_APPLICATION_JSON '{"server":{"port":8080}}'

# Run the application
CMD ["java", "-jar", "your-application.jar"]
