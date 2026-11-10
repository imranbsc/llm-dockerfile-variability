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
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use a lightweight image for the final container
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built Go application from the builder stage
COPY --from=builder /app/main .

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["./main"]
