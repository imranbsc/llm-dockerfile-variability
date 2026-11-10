# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file from the build directory to the container
COPY target/your-tool-name.jar /app/your-tool-name.jar

# Expose the port on which the tool will run (if applicable)
EXPOSE 8080

# Define the command to run the tool
CMD ["java", "-jar", "your-tool-name.jar"]
