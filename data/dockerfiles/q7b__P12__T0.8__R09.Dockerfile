# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the maintainer of the Docker image
LABEL maintainer="your.email@example.com"

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the Spring Boot application
RUN ./mvnw clean package -DskipTests

# Expose port 8080
EXPOSE 8080

# Run the application when the container launches
CMD ["java", "-jar", "target/your-application-name.jar"]
