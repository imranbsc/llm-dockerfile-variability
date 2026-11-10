# Use an official Go runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the Go application source code into the container at /app
COPY . /app

# Install any needed packages specified in go.mod
RUN go mod download

# Build the Go application
RUN go build -o app

# Expose the default HTTP port
EXPOSE 8080

# Run the application
CMD ["./app"]
