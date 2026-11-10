# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 5005 available to the world outside this container
EXPOSE 5005

# Define environment variable
ENV JAVA_OPTS="-Xmx512m"

# Make port 9090 available to the world outside this container
EXPOSE 9090

# Run the application using picocli
CMD ["java", "-jar", "your-application.jar"]
