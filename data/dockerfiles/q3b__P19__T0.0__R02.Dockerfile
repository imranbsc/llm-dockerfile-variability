# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/spf13/cobra

# Build the Go app
RUN CGO_ENABLED=0 go build -o app main.go

# Expose the port the app runs on
EXPOSE 8080

# Run the app
CMD ["./app"]
