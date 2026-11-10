# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file into the container
COPY target/your-tool-name.jar /app/your-tool-name.jar

# Define the entry point for the container
ENTRYPOINT ["java", "-jar", "your-tool-name.jar"]
