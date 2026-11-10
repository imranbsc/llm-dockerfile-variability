# Use the official Golang image as the base image
FROM golang:latest

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the Go application source code into the container
COPY . .

# Install dependencies
RUN go get -u github.com/spf13/cobra@v1.7.1

# Build the Go application
RUN CGO_ENABLED=0 go build -o app main.go

# Expose the port that the application listens on
EXPOSE 8080

# Run the application
CMD ["./app"]
