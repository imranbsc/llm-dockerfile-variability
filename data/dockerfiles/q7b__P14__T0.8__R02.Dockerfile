# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the compiled JAR file from your local machine to the container
COPY target/your-tool-name.jar /app/your-tool-name.jar

# Define the command to run the JAR file when the container starts
CMD ["java", "-jar", "your-tool-name.jar"]
