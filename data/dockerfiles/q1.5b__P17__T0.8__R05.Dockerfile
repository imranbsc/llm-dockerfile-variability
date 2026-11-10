# Use an official Go runtime as a parent image
FROM golang:1.17.9-slim

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod and go.sum
RUN go build -o webapp

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
ENV NAME World

# Run the webapp in the background
CMD ["./webapp"]
