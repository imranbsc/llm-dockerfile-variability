# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY target/your-spring-boot-app.jar /app/your-spring-boot-app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Run the application using the command line argument
CMD ["java", "-jar", "your-spring-boot-app.jar"]
