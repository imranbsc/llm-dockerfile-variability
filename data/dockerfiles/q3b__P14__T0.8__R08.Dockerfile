# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV JAVA_OPTS="-Dpicocli.jcommander.enableAutoMap=true"

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 443 available to the world outside this container
EXPOSE 443

# Run the application
CMD ["java", "-jar", "your-jar-file.jar"]
