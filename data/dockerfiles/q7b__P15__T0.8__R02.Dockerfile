# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/your-spring-batch-job.jar /app/your-spring-batch-job.jar

# Expose the port that the batch job will listen on
EXPOSE 8080

# Set the command to run the batch job
CMD ["java", "-jar", "your-spring-batch-job.jar"]
