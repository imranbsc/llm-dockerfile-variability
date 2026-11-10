# Use an official Go runtime as a parent image
FROM golang:1.17-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go module files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source code into the container at /app
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o mytool .

# Use an official lightweight image to run the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/mytool .

# Command to run the application
CMD ["./mytool"]
