# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code from the current directory to the working directory
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a minimal container to run the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["./main"]
