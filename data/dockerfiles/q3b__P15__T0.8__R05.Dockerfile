# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application build artifacts into the container
COPY target/your-spring-batch-app.jar /app/your-spring-batch-app.jar

# Expose the port your application listens on
EXPOSE 8080

# Define environment variables
ENV SPRING_BATCH_JOB_NAME=your-spring-batch-job
ENV SPRING_BATCH_JOB_NAME_SCHEDULE=0 0 * * * ?  # Example cron schedule for daily at midnight

# Start the Spring Boot application
CMD ["java", "-jar", "your-spring-batch-app.jar"]
