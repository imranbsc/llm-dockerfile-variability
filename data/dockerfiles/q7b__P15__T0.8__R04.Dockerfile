# Use an official OpenJDK image as the base image
FROM openjdk:17-jdk-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the local Maven repository to the container to avoid downloading dependencies every time
COPY settings.xml /usr/share/maven/ref/settings.xml

# Copy the project's pom.xml and all src files into the container
COPY pom.xml .
COPY src src

# Build the project
RUN mvn clean package -DskipTests

# Use a smaller image for the final image
FROM openjdk:17-jre-slim

# Copy the built JAR file from the build stage
COPY --from=build /app/target/your-application.jar /app/your-application.jar

# Set the working directory in the container
WORKDIR /app

# Define the environment variables
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom"

# Expose the application port
EXPOSE 8080

# Schedule the batch job using cron
RUN echo "0 * * * * java $JAVA_OPTS -jar your-application.jar --spring.profiles.active=prod" > /etc/cron.d/spring-batch-job

# Make the cron file executable
RUN chmod 0644 /etc/cron.d/spring-batch-job

# Install cron
RUN apt-get update && apt-get install -y cron && rm -rf /var/lib/apt/lists/*

# Start cron and the application
CMD ["sh", "-c", "cron && java $JAVA_OPTS -jar your-application.jar --spring.profiles.active=prod"]
