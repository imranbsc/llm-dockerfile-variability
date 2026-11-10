# Use an official Go runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/pkg/errors

# Build the Go application
RUN CGO_ENABLED=0 go build -o app main.go

# Expose the port the application listens on
EXPOSE 8080

# Run the application
CMD ["./app"]
