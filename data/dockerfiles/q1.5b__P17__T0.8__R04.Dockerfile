# Use a Go runtime as the base image
FROM golang:1.18

# Set the working directory in the container
WORKDIR /app

# Copy the Go source code into the container
COPY . .

# Build the Go application
RUN go build -o server

# Set the environment variable for the server port
ENV PORT=8080

# Run the Go server when the container starts
CMD ["./server"]
