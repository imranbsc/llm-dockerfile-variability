# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 8081 available to the world outside this container
EXPOSE 8081

# Define environment variable
ENV SPRING_APPLICATION_JSON '{"server":{"port":8080},"batch":{"job":{"names":{"exampleJob":"exampleJob"}}}}'

# Run the application using the specified command
CMD ["java", "-jar", "target/example-batch-job-0.0.1-SNAPSHOT.jar"]
