# Use the official Go image as the base image
FROM golang:1.21-alpine as builder

# Set the working directory in the container
WORKDIR /go/src/api

# Copy the Go source files into the container
COPY . .

# Build the Go application
RUN go build -o api .

# Use the official Alpine image as the base image for the final image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built application from the builder image
COPY --from=builder /go/src/api/api .

# Expose the default port for the API
EXPOSE 8080

# Run the application
CMD ["./api"]
