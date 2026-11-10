# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file containing the command-line tool into the container
COPY target/your-tool-name.jar /app/your-tool-name.jar

# Define the command to run the command-line tool
CMD ["java", "-jar", "your-tool-name.jar"]
