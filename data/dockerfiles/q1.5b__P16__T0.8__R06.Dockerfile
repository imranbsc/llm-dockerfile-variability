# Use an official Go runtime as a parent image
FROM golang:1.17.5

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in requirements.txt
RUN go get -v -u

# Build the Go application
RUN go build -o my-app

# Expose the port the application is listening on
EXPOSE 8080

# Define environment variable
ENV NAME=World

# Run the app
CMD ["./my-app"]
