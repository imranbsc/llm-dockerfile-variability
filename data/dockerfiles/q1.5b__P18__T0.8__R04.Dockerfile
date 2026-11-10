# Use a Go runtime as the base image
FROM golang:1.18 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go source code into the container
COPY . /app

# Build the Go application
RUN go build -o worker

# Create a Dockerfile for the background worker image
FROM scratch

# Copy the compiled binary into the image
COPY worker /app

# Set the entrypoint of the container
ENTRYPOINT ["/app/worker"]
