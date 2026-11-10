# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get install -y curl && \
    curl -L https://repo.spring.io/maven2/org/springframework/boot/spring-boot-cli/2.6.7/spring-boot-cli-2.6.7.jar -o /usr/local/bin/spring

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV SPRING_APPLICATION_JSON '{"server":{"port":8080}}'

# Run the application using the specified main class
CMD ["java", "-jar", "target/your-application.jar"]
