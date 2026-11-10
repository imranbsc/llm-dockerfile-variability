# Use the official Go image as the base image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache git

# Build the Go application
RUN go build -o myapp

# Expose the port your application is running on
EXPOSE 8080

# Run the application
CMD ["./myapp"]
