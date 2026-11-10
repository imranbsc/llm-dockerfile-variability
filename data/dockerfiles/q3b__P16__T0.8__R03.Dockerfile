# Use the official Golang image as the base image
FROM golang:1.16-alpine

# Set the working directory in the container
WORKDIR /go/src/api

# Copy the current directory contents into the container at /go/src/api
COPY . .

# Install any needed packages specified in requirements.txt
RUN apk add --no-cache git

# Build the Go binary
RUN go build -o api .

# Expose the port the Go app will listen on
EXPOSE 8080

# Run the built Go binary
CMD ["./api"]
