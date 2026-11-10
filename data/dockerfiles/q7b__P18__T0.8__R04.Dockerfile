# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use a smaller image for the final container
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built binary from the builder stage
COPY --from=builder /app/main .

# Set the command to run the application
CMD ["./main"]
