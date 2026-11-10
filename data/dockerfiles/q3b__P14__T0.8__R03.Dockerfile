# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in pom.xml/gradle.build
RUN mvn install || gradle build

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the application, mapping port 8080 of the container to port 8080 of the host
CMD ["java", "-jar", "target/your-application.jar"]
