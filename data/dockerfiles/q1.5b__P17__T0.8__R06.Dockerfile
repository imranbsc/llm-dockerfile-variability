# Use an official Go runtime as a parent image
FROM golang:1.17

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install dependencies
RUN go mod download

# Build the Go application
RUN go build -o server

# Define environment variable
ENV PORT=8080

# Expose the port the application will listen on
EXPOSE $PORT

# Run the application
CMD ["./server"]
