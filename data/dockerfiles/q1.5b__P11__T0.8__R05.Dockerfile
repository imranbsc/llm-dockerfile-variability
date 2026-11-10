# Use an official openjdk runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in package.json
# COPY package*.json ./
# RUN apt-get update && apt-get install -y nodejs

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the app as the root user
RUN chmod +x ./mvnw

# Run the Spring Boot app
CMD ["./mvnw", "spring-boot:run"]
