# Use an official Go runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/gorilla/mux

# Build the Go application
RUN go build -o app

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["./app"]
