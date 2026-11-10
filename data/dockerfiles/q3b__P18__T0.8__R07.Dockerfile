# Use an official Go runtime as a parent image
FROM golang:1.19-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN go get -u github.com/go-redis/redis/v8

# Build the Go application
RUN go build -o asynq_worker cmd/asynq_worker/main.go

# Expose the default port used by Asynq
EXPOSE 6379

# Define environment variables for Asynq
ENV ASYNQ_ADDR="redis://localhost:6379"
ENV ASYNQ_QUEUE_NAME="default"

# Run the application
CMD ["./asynq_worker"]
