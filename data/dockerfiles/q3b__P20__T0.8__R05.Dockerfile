# Use an official Go runtime as a parent image
FROM golang:1.18 AS builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the Go application code into the container
COPY . .

# Build the Go application
RUN go build -o /app/app

# Use a minimal image for the final container
FROM alpine:3.15

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the build stage
COPY --from=builder /app/app .

# Expose the port the application listens on
EXPOSE 8080

# Define environment variables
ENV CRON_SCHEDULE="* * * * *"

# Run the application
CMD ["./app"]
