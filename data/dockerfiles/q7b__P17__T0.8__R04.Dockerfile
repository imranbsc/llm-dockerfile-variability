# Use an official Go runtime as a parent image
FROM golang:1.17-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application code to the working directory
COPY . .

# Build the Go application
RUN go build -o main .

# Use an official lightweight HTTP server as a parent image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080
EXPOSE 8080

# Run the Go application when the container launches
CMD ["./main"]
