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
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Use an official lightweight runtime as a parent image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built Go binary from the builder stage
COPY --from=builder /app/main .

# Expose the port the app runs on
EXPOSE 8080

# Command to run the application
CMD ["./main"]
