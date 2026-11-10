# Use an official Go runtime as a parent image
FROM golang:1.17-alpine

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in requirements.txt
RUN go get -u github.com/spf13/cobra@latest

# Build the Go application
RUN go build -o your-app

# Make port 80 available to the world outside this container
EXPOSE 80

# Run your app
CMD ["/usr/src/app/your-app"]
