# Use an official Go runtime as a parent image
FROM golang:1.21-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files into the container at /app
COPY go.mod go.sum ./

# Install any needed packages specified in go.mod
RUN go mod download

# Copy the rest of the application code into the container at /app
COPY . .

# Build the Go application
RUN go build -o asynq-worker

# Use an official Alpine image for the final runtime
FROM alpine:3.16

# Set the working directory in the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/asynq-worker .

# Expose the port the worker will listen on
EXPOSE 6315

# Run the worker
CMD ["./asynq-worker"]
