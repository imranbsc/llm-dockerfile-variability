# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built Spring Boot application jar file into the container
COPY target/your-application.jar /app/your-application.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Run the application when the container launches
CMD ["java", "-jar", "your-application.jar"]
