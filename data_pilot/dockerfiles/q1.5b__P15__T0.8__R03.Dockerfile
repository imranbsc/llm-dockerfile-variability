# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in pom.xml
RUN mvn install

# Expose the port where the Spring Boot application will listen
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "target/spring-boot-web-api.jar"]
