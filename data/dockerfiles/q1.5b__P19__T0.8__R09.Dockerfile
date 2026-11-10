# Use an official Go runtime as a parent image
FROM golang:1.17

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in the Gopkg.toml file
RUN go mod download

# Build the Go application
RUN go build -o my-tool

# Make port 80 available to the world outside this container
EXPOSE 80

# Run the application when the container launches
CMD ["./my-tool"]
