# Use an official openjdk runtime as a parent image
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in pom.xml
RUN mvn dependency:resolve && mvn dependency:copy-dependencies -DoutputDirectory=target/classes

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variables
ENV SPRING_DATASOURCE_URL=${SPRING_DATASOURCE_URL:-jdbc:postgresql://localhost:5432/yourdatabase}
ENV SPRING_DATASOURCE_USERNAME=${SPRING_DATASOURCE_USERNAME:-yourusername}
ENV SPRING_DATASOURCE_PASSWORD=${SPRING_DATASOURCE_PASSWORD:-yourpassword}

# Run the app using the Spring Boot executable
CMD ["java", "-jar", "target/yourapp.jar"]
