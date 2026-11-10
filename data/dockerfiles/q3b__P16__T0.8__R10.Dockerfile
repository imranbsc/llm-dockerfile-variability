# Use an official Golang runtime as a parent image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache git

# Build the Go app
RUN go build -o main

# Use an official Alpine Linux runtime as a parent image for the final image
FROM alpine:3.15

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /app/main .

# Expose the port your application runs on
EXPOSE 8080

# Run the app
CMD ["./main"]
