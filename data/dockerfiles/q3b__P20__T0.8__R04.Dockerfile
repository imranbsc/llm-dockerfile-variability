# Use the official Go image as the base image
FROM golang:1.21-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN apk add --no-cache git

# Build the application
RUN CGO_ENABLED=0 go build -o main main.go

# Expose the port your application is listening on
EXPOSE 8080

# Run the application
CMD ["./main"]
