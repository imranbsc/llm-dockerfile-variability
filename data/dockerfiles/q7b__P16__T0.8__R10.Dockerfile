# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the working directory in the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Start a new stage from a lightweight image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application when the container starts
CMD ["./main"]
