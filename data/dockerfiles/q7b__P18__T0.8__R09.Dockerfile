# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go module and vendor files
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o worker .

# Use an official lightweight Alpine image as a final image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built application from the builder stage
COPY --from=builder /app/worker .

# Run the application
CMD ["./worker"]
