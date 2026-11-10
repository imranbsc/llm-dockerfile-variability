# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Make port 5432 available to the world outside this container (PostgreSQL)
EXPOSE 5432

# Add a volume for PostgreSQL data
VOLUME /app/data

# Define environment variables for database connection
ENV POSTGRES_DB=${POSTGRES_DB:-springbootdb}
ENV POSTGRES_USER=${POSTGRES_USER:-springbootuser}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-springbootpassword}

# Run the application
CMD ["java", "-jar", "target/springbootapp-0.0.1-SNAPSHOT.jar"]
