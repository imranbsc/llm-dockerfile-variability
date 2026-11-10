# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
# RUN apt-get update && apt-get install -y --no-install-recommends <package_name>

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the app when the container launches
CMD ["java", "-cp", "target/classes", "com.example.Main"]
