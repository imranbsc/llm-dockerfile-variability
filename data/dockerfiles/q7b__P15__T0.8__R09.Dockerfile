# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the maintainer label
LABEL maintainer="your-email@example.com"

# Set the working directory in the container
WORKDIR /app

# Copy the compiled Java application jar into the container
COPY target/your-application.jar /app/your-application.jar

# Define environment variables
ENV JAVA_OPTS="-Xmx512m"

# Define the command to run the Spring Batch application
CMD ["sh", "-c", "java ${JAVA_OPTS} -jar your-application.jar"]
