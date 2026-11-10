# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the application using Maven
RUN ./mvnw clean package -DskipTests

# Expose port 8080
EXPOSE 8080

# Set environment variables for PostgreSQL connection
ENV SPRING_DATASOURCE_URL=jdbc:postgresql://db:5432/mydb
ENV SPRING_DATASOURCE_USERNAME=myuser
ENV SPRING_DATASOURCE_PASSWORD=mypassword

# Run the application when the container launches
CMD ["java", "-jar", "target/myapp.jar"]
