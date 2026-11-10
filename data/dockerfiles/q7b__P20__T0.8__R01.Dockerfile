# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a smaller base image for the final image
FROM alpine:latest

# Copy the binary from the builder stage
COPY --from=builder /app/main /app/main

# Set the working directory
WORKDIR /app

# Expose the port that the job will run on
EXPOSE 8080

# Run the job using cron
CMD ["sh", "-c", "cron -f -L 1"]
