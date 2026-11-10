# Use an official Go runtime as a parent image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go application
RUN CGO_ENABLED=0 go build -o asynq-worker main.go

# Use an official Alpine image as a parent image for the final image
FROM alpine:3.15

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/asynq-worker .

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["./asynq-worker"]
