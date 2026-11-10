# Use an official Go runtime as a parent image
FROM golang:1.17-alpine as build-env

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in requirements.txt
RUN go mod download

# Build the Go application
RUN CGO_ENABLED=0 go build -o app

# Use an official lightweight base image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the build-env to the new image
COPY --from=build-env /go/src/app/app .

# Expose the port that the application runs on
EXPOSE 8080

# Run the application
CMD ["./app"]
