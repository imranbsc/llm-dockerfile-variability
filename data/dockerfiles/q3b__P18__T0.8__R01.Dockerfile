# Use an official Golang runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the Go application source code into the container
COPY . /app

# Install any needed packages specified in requirements.txt
RUN apk update && apk add --no-cache \
    git \
    make \
    && go mod download

# Build the Go application
RUN CGO_ENABLED=0 go build -o asynq_worker cmd/asynq_worker/main.go

# Expose the port the application runs on
EXPOSE 6379

# Run the application when the container launches
CMD ["/app/asynq_worker"]
