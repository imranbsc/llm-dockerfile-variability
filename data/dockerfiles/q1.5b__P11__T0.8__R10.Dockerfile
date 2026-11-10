# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in package.json
RUN apt-get update && apt-get install -y \
    maven \
    && rm -rf /var/lib/apt/lists/*

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the Spring Boot app using Maven
CMD ["mvn", "spring-boot:run"]
