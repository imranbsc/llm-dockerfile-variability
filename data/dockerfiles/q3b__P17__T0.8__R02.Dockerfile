# Use an official Go runtime as a parent image
FROM golang:1.18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod
RUN go get -v ./...

# Expose the port your application is listening on
EXPOSE 8080

# Run the application
CMD ["go", "run", "main.go"]
