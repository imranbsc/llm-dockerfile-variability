# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o api .

# Use a lightweight base image for the production environment
FROM alpine:latest

# Copy the compiled binary from the builder stage
COPY --from=builder /app/api /usr/local/bin/api

# Expose the port the app runs on
EXPOSE 8080

# Run the app
CMD ["api"]
