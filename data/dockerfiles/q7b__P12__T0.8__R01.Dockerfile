# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the application JAR file into the container
COPY target/your-spring-boot-app.jar /app/your-spring-boot-app.jar

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-spring-boot-app.jar"]
