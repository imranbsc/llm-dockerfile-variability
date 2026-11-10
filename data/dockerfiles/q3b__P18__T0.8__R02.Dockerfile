# Use a Go base image
FROM golang:1.19 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go source files into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 go build -o asynq_worker

# Use an alpine image as the final image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built binary from the builder stage
COPY --from=builder /app/asynq_worker .

# Expose the port on which Asynq runs
EXPOSE 6379

# Run the Asynq worker
CMD ["./asynq_worker"]
