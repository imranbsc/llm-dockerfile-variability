# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the JAR file
RUN ./mvnw clean package

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the JAR file when the container launches
CMD ["java", "-jar", "target/your-application-name.jar"]
