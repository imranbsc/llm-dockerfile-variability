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
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o main .

# Start the worker using Asynq
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the compiled binary from the builder stage
COPY --from=builder /app/main .

# Create a directory for the worker to store its data
RUN mkdir /var/lib/asynq

# Set the command to run the worker
CMD ["./main"]
