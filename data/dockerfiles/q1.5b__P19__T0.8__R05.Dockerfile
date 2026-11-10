# Use an official Go runtime as a parent image
FROM golang:1.17.6 AS builder

# Set the working directory in the container
WORKDIR /go/src/app

# Copy the current directory contents into the container at /go/src/app
COPY . .

# Install any needed packages specified in go.mod and go.sum
RUN go build -o /usr/local/bin/command-line-tool

# Define the command to run
CMD ["command-line-tool"]

# Allow the container to be executed with root privileges
RUN groupadd -r myuser
RUN useradd -r -g myuser myuser
USER myuser

# Expose the port(s) that the application will listen on
EXPOSE 8080

# Define environment variables
ENV APP_NAME command-line-tool
ENV APP_PORT 8080
