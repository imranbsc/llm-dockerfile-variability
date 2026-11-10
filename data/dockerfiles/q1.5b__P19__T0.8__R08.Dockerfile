# Use an official Go runtime as a parent image
FROM golang:1.16

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Install any needed packages specified in go.mod and go.sum
RUN go build -o cmd/mycommand

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variables
ENV NAME=World

# Run the command when the container launches
CMD ["./cmd/mycommand"]
