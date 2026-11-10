# Use an official Go runtime as a parent image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the Go application
RUN CGO_ENABLED=0 go build -o app .

# Use an official lightweight base image
FROM alpine:3.14

# Copy the binary from the builder stage to the final image
COPY --from=builder /app/app /app

# Expose the port your application runs on
EXPOSE 8080

# Define environment variables
ENV APP_ENV=production

# Set the entry point for the application
CMD ["/app/app"]
