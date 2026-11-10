# Use an official Go runtime as a parent image
FROM golang:1.16

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in go.mod
RUN go get -u -v ./...

# Build the Go application
RUN go build -o app

# Run the built application
CMD ["./app"]
