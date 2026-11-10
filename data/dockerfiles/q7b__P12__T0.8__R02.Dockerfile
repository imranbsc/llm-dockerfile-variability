# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Spring Boot application jar file into the container
COPY target/your-spring-boot-app.jar app.jar

# Define the port on which the application will run
EXPOSE 8080

# Run the Spring Boot application when the container launches
CMD ["java", "-jar", "app.jar"]
