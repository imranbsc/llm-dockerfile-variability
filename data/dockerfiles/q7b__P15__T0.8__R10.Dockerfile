# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built jar file into the container
COPY target/your-spring-batch-job.jar /app/your-spring-batch-job.jar

# Define the environment variable for Spring Batch configuration
ENV SPRING_BATCH_JOB_NAME=yourJobName
ENV SPRING_BATCH_JOB_PARAMS=yourJobParams

# Run the Spring Batch job using the java command
CMD ["java", "-jar", "your-spring-batch-job.jar", "--spring.batch.job.name=${SPRING_BATCH_JOB_NAME}", "--spring.batch.job.parameters=${SPRING_BATCH_JOB_PARAMS}"]
