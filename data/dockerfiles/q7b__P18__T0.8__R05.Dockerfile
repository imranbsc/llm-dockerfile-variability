# Use an official Go runtime as a parent image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -o worker .

# Use a smaller image to run the application
FROM alpine:latest

# Copy the binary from the builder stage
COPY --from=builder /app/worker /usr/local/bin/worker

# Set the command to run the application
CMD ["/usr/local/bin/worker"]
