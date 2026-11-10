# Use the official Golang image as the base
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Build the Go application
RUN go build -o asynq-worker main.go

# Expose the port that the application runs on
EXPOSE 6379

# Run the application
CMD ["./asynq-worker"]
