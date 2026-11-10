# Use the official Go image
FROM golang:1.16-alpine as build

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/spf13/cobra

# Build the Go application
RUN CGO_ENABLED=0 go build -o app ./cmd/main

# Use the official Alpine image as a parent image
FROM alpine:3.13

# Set the working directory in the container
WORKDIR /app

# Copy the binary from the build stage
COPY --from=build /go/src/app/app .

# Expose the application port
EXPOSE 8080

# Command to run the application
CMD ["./app"]
