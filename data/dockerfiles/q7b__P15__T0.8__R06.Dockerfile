# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the Maven repository to the container to avoid downloading dependencies again
COPY ~/.m2 /root/.m2

# Copy the project's pom.xml and all the dependencies
COPY pom.xml ./

# Build the project using Maven
RUN mvn clean package -DskipTests

# Copy the built JAR file from the target directory to the container
COPY target/*.jar app.jar

# Expose the port that your application is running on
EXPOSE 8080

# Define the environment variable for the Spring Batch configuration
ENV SPRING_BATCH_JOB_NAME=your_job_name

# Define the entry point to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
