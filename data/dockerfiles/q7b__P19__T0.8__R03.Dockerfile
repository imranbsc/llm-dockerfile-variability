# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o mytool .

# Use a smaller image to run the application
FROM alpine:latest

# Create the working directory
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/mytool .

# Set the entrypoint of the container
ENTRYPOINT ["/app/mytool"]
