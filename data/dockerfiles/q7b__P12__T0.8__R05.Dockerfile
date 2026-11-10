# Use an official openjdk runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the application using Maven
RUN ./mvnw clean package -DskipTests

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application when the container launches
CMD ["java", "-jar", "target/myapp-0.0.1-SNAPSHOT.jar"]
