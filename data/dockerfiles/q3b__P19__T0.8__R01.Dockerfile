# Use an official Golang runtime as a parent image
FROM golang:1.17

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the Go application source code into the container
COPY . .

# Install any needed packages specified in go.mod
RUN go get -u -v ./...

# Build the Go application
RUN CGO_ENABLED=0 go build -o /app/app

# Expose the port the application listens on
EXPOSE 8080

# Run the application when the container launches
CMD ["/app/app"]
