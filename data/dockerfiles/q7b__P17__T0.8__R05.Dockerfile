# Use an official Go runtime as a parent image
FROM golang:1.17 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the application
RUN go build -o main .

# Use an official lightweight base image for the production environment
FROM alpine:latest

# Set the working directory in the container
WORKDIR /root/

# Copy the built application from the builder stage
COPY --from=builder /app/main .

# Expose the port that the application runs on
EXPOSE 8080

# Command to run the application
CMD ["./main"]
