# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in package.json
RUN mvn clean install

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variables
ENV SPRING_PROFILES_ACTIVE=prod

# Run the app
CMD ["java", "-jar", "target/myapp.jar"]
