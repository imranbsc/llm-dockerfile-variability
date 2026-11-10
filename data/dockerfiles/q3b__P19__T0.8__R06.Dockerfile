# Use an official Golang runtime as a parent image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Build the Go app
RUN go build -o app main.go

# Expose the port the app runs on
EXPOSE 8080

# Run the app when the container launches
CMD ["./app"]
