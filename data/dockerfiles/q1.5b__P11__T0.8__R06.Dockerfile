# Use an official openjdk runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Build the application using Maven
RUN mvn clean install

# Expose the default port for the application
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "target/*.jar"]
