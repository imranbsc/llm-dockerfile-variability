# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Set the working directory in the container
WORKDIR /app

# Copy the local Maven project to the working directory
COPY . /app

# Build the Spring Batch application
RUN ./mvnw clean package -DskipTests

# Expose the application port
EXPOSE 8080

# Define the environment variable for Spring Batch configuration
ENV SPRING_BATCH_JOB_NAME=scheduledJob

# Command to run the Spring Batch application
CMD ["java", "-jar", "target/your-application-name.jar", "--spring.batch.job.names=${SPRING_BATCH_JOB_NAME}"]
