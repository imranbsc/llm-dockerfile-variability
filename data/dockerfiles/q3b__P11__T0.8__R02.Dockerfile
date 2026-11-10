# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV JAVA_OPTS=""

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV JAVA_OPTS=""

# Run the application
CMD ["java", "-jar", "target/your-spring-boot-app.jar"]
