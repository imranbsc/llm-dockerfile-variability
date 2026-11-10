# Use the official Go image as the base image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache git

# Build the Go application
RUN go build -o app server.go

# Use an official lightweight image for the runtime
FROM alpine:3.14

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage to the runtime stage
COPY --from=builder /app/app .

# Expose the port on which the application will run
EXPOSE 8080

# Run the application
CMD ["./app"]
