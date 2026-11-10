# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -v

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run your Go application
CMD ["go", "run", "main.go"]
