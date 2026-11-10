# Use a base image with a recent version of Go
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the Go source code into the container
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code into the container
COPY . .

# Build the Go application
RUN CGO_ENABLED=0 go build -o app

# Use a minimal base image for running the application
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the pre-built Go application from the builder stage
COPY --from=builder /app/app .

# Expose the port the application runs on
EXPOSE 8080

# Set the entry point for the application
CMD ["./app"]
