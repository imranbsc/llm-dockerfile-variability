# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o worker .

# Use a smaller base image for the final container
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/worker .

# Set the command to run the application
CMD ["./worker"]
