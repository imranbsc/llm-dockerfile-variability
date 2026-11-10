# Use an official Go runtime as a parent image
FROM golang:1.20

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . /go/src/app

# Install any needed packages specified in go.mod
RUN go get -d -v ./...

# Build the application
RUN CGO_ENABLED=0 go build -o app .

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application
CMD ["./app"]
