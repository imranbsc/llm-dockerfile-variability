# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the local project files into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Build the Spring Batch application
RUN ./mvnw clean package

# Copy the built JAR file into the container
COPY --from=0 /app/target/your-spring-batch-app-*.jar app.jar

# Expose the port that the Spring Batch application will run on
EXPOSE 8080

# Run the Spring Batch application
CMD ["java", "-jar", "app.jar"]
