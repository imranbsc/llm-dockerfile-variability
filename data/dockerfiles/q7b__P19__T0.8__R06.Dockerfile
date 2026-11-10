# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o mytool

# Use a minimal image to run the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/mytool /app/mytool

# Make the application executable
RUN chmod +x /app/mytool

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./mytool"]
