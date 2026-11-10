# Use an official Go runtime as a parent image
FROM golang:1.17 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the content of the local src directory to the working directory
COPY . .

# Build the Go app
RUN go build -o main .

# Use a smaller image to run the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the executable from the builder stage
COPY --from=builder /app/main .

# Command to run the application
CMD ["./main"]
