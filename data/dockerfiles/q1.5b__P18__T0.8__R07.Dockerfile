# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN go mod download

# Build the binary
RUN go build -o worker

# Create a non-root user to run the application
RUN useradd -ms /bin/bash worker

# Copy the binary to the non-root user's home directory
COPY worker /home/worker

# Set the working directory for the non-root user
WORKDIR /home/worker

# Expose the port the application is running on
EXPOSE 8080

# Run the application as the non-root user
CMD ["./worker"]
