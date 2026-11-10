# Use an official Go runtime as a parent image
FROM golang:1.17-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files don't change.
RUN go mod download

# Copy the content of the local src directory to the working directory
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use an official lightweight image for the runtime
FROM alpine:latest

# Copy the binary from the builder stage
COPY --from=builder /app/main /app/main

# Set the working directory in the container
WORKDIR /app

# Run the Go app
CMD ["./main"]
