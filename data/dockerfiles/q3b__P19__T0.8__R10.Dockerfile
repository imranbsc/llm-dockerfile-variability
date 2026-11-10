# Use an official Go runtime as a parent image
FROM golang:1.17-alpine as builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in Gopkg.lock
RUN go mod tidy

# Build the Go application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /go/bin/app main.go

# Use an official Alpine image as a final runtime image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the pre-built binary from the builder stage
COPY --from=builder /go/bin/app /app/app

# Expose the port the application runs on
EXPOSE 8080

# Run the application
CMD ["./app"]
