# Use an official Go runtime as a parent image
FROM golang:1.16

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod and go.sum
RUN go get -v -t .

# Build the application
RUN go build -o server

# Expose the port the application is listening on
EXPOSE 8080

# Run the application when the container launches
CMD ["./server"]
