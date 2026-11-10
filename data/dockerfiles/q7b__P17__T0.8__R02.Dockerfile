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
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o main .

# Use a minimal Debian-based image for the runtime
FROM debian:bullseye-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/main .

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["./main"]
