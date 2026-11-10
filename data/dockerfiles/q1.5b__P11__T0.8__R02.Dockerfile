# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container to /usr/src/app
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . /usr/src/app

# Install any needed packages specified in the requirements.txt file
RUN apt-get update && apt-get install -y maven

# Set the environment variable
ENV SPRING_PROFILES_ACTIVE=prod

# Build the app using Maven
RUN mvn clean install

# Run the app
CMD ["java", "-jar", "target/your-application-name.jar"]
