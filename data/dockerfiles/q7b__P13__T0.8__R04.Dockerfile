# Use the official openjdk image as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY target/my-spring-boot-app.jar /app/my-spring-boot-app.jar

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "my-spring-boot-app.jar"]
