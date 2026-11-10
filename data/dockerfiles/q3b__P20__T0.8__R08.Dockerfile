# Use an official Golang runtime as a parent image
FROM golang:1.16-slim

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/robfig/cron/v3

# Build the Go app
RUN go build -o app

# Run the app
CMD ["./app"]
