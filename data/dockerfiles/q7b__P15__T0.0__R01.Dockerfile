# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the Spring Batch application
RUN ./mvnw clean package -DskipTests

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV JAVA_OPTS="-Xmx512m -Xms256m"

# Run the application when the container launches
CMD ["java", "${JAVA_OPTS}", "-jar", "target/your-spring-batch-app.jar"]
