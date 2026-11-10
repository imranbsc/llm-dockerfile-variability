# Use an official Golang runtime as a parent image
FROM golang:1.16-alpine as builder

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go mod download && \
    go build -o api main.go

# Use an official Alpine runtime as a parent image
FROM alpine:3.14

# Copy the executable from the builder image to the new image
COPY --from=builder /app/api /api

# Set the entry point for the container
ENTRYPOINT ["/api"]
