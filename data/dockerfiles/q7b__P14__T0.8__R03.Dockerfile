# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled Java JAR file into the container
COPY target/your-tool-name.jar /app/your-tool-name.jar

# Define the command to run your Java application using picocli
CMD ["java", "-jar", "your-tool-name.jar"]
