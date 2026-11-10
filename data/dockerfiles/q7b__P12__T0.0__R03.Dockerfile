# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the application
RUN ./mvnw clean package -DskipTests

# Expose the port the application runs on
EXPOSE 8080

# Run the application when the container launches
CMD ["java", "-jar", "target/your-application-name.jar"]
