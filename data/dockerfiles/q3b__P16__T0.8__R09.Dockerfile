# Use an official Go runtime as a parent image
FROM golang:1.19 as build-env

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in requirements.txt
RUN go get -d -v ./...

# Build the Go application
RUN go build -o app

# Use an official lightweight base image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the build-env to the new image
COPY --from=build-env /go/src/app/app /app/app

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the app
CMD ["./app"]
