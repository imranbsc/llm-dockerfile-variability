# Use the official Go image as the base image
FROM golang:1.21 AS builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Build the Go application
RUN go build -o app ./cmd/app

# Use alpine as the final runtime image
FROM alpine:latest

# Copy the built application from the builder image to the final image
COPY --from=builder /go/src/app/app /app

# Set the entrypoint of the container
ENTRYPOINT ["/app"]
