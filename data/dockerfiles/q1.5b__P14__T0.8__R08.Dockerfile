# Use an official openjdk runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the requirements.txt file
RUN apt-get update && apt-get install -y \
    && rm -rf /var/lib/apt/lists/*

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run app.jar when the container launches
CMD ["java", "-jar", "app.jar"]
