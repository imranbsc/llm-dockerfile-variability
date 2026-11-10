# Use an official Java runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Spring Boot application jar file into the container
COPY target/your-spring-boot-app.jar /app/your-spring-boot-app.jar

# Expose the port that the application is running on
EXPOSE 8080

# Run the application when the container launches
CMD ["java", "-jar", "your-spring-boot-app.jar"]
