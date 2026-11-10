# Use an official Java runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the Dockerfile
RUN apt-get update && apt-get install -y \
    liblog4j2-java \
    && rm -rf /var/lib/apt/lists/*

# Set the environment variable to the batch application entrypoint
ENV BATCH_APPLICATION=/app/target/batch-app.jar

# Expose the port the batch application will listen on
EXPOSE 8080

# Run the batch application when the container launches
CMD ["java", "-jar", BATCH_APPLICATION]
