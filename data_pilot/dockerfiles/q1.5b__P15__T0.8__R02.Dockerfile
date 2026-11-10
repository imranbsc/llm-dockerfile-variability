# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in pom.xml
RUN mvn install

# Run the app
CMD ["java", "-jar", "target/my-java-spring-boot-api.jar"]
