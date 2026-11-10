# Use an official openjdk runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
# RUN apt-get update && apt-get install -y \
#     # Add any packages here

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME World

# Run the app at container startup
CMD ["java", "-jar", "target/spring-batch-jpa-example.jar"]
