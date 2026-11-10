# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file from the local machine to the container
COPY target/your-spring-boot-app.jar your-spring-boot-app.jar

# Expose the port your Spring Boot app is running on
EXPOSE 8080

# Define environment variables for the application
ENV SPRING_APPLICATION_JSON={"server":{"port":8080}}

# Start the application
CMD ["java", "-jar", "your-spring-boot-app.jar"]
